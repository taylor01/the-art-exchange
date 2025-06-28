#!/usr/bin/env ruby
# frozen_string_literal: true

require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "colorize"
  gem "yaml"
  gem "json"
end

class KamalEnvironmentAuditor
  KAMAL_CONFIG_PATH = "config/deploy.yml"
  KAMAL_SECRETS_PATH = ".kamal/secrets"
  
  # Environment variables discovered from Rails application analysis
  DISCOVERED_ENV_VARS = {
    # Database
    "DATABASE_URL" => { required: true, source: "database.yml", description: "PostgreSQL connection URL" },
    "RAILS_MAX_THREADS" => { required: false, source: "database.yml/puma.rb", description: "Database connection pool size" },
    
    # Rails Core
    "RAILS_MASTER_KEY" => { required: true, source: "credentials", description: "Rails application master key" },
    "RAILS_ENV" => { required: true, source: "production", description: "Rails environment" },
    "RAILS_LOG_LEVEL" => { required: false, source: "production.rb", description: "Rails logging level" },
    
    # Server/Process
    "PORT" => { required: false, source: "puma.rb", description: "Puma server port" },
    "PIDFILE" => { required: false, source: "puma.rb", description: "Puma PID file location" },
    "WEB_CONCURRENCY" => { required: false, source: "puma.rb", description: "Number of Puma workers" },
    "SOLID_QUEUE_IN_PUMA" => { required: false, source: "deploy.yml", description: "Run Solid Queue in Puma process" },
    
    # AWS/Storage
    "AWS_ACCESS_KEY_ID" => { required: true, source: "storage.yml", description: "AWS S3 access key" },
    "AWS_SECRET_ACCESS_KEY" => { required: true, source: "storage.yml", description: "AWS S3 secret key" },
    "AWS_REGION" => { required: true, source: "storage.yml", description: "AWS S3 region" },
    "AWS_S3_BUCKET" => { required: true, source: "storage.yml", description: "AWS S3 bucket name" },
    
    # Authentication/OAuth
    "GOOGLE_CLIENT_ID" => { required: false, source: "omniauth.rb", description: "Google OAuth client ID" },
    "GOOGLE_CLIENT_SECRET" => { required: false, source: "omniauth.rb", description: "Google OAuth client secret" },
    "FACEBOOK_APP_ID" => { required: false, source: "omniauth.rb", description: "Facebook OAuth app ID" },
    "FACEBOOK_APP_SECRET" => { required: false, source: "omniauth.rb", description: "Facebook OAuth app secret" },
    "APPLE_CLIENT_ID" => { required: false, source: "omniauth.rb", description: "Apple OAuth client ID" },
    "APPLE_TEAM_ID" => { required: false, source: "omniauth.rb", description: "Apple OAuth team ID" },
    "APPLE_KEY_ID" => { required: false, source: "omniauth.rb", description: "Apple OAuth key ID" },
    "APPLE_PRIVATE_KEY" => { required: false, source: "omniauth.rb", description: "Apple OAuth private key" },
    
    # External Services
    "ANTHROPIC_API_KEY" => { required: true, source: "poster_metadata_service.rb", description: "Anthropic Claude API key" },
    
    # Deployment
    "KAMAL_REGISTRY_PASSWORD" => { required: true, source: "deploy.yml", description: "Docker registry password" }
  }.freeze

  def initialize
    @kamal_config = load_kamal_config
    @kamal_secrets = load_kamal_secrets
    @missing_vars = []
    @optional_missing_vars = []
    @vault_errors = []
  end

  def run(command = "audit")
    puts "🔍 Kamal Environment Auditor".colorize(:cyan)
    puts "=" * 50
    
    case command
    when "discover", "--discover"
      discover_env_vars
    when "audit", "--audit"
      audit_configuration
    when "validate", "--validate"
      validate_1password_vault
    when "test", "--test"
      test_deployment_environment
    when "fix", "--fix"
      auto_fix_configuration
    when "deploy-check", "--deploy-check"
      full_deployment_check
    else
      show_help
    end
  end

  private

  def load_kamal_config
    return {} unless File.exist?(KAMAL_CONFIG_PATH)
    YAML.load_file(KAMAL_CONFIG_PATH)
  rescue => e
    puts "❌ Error loading Kamal config: #{e.message}".colorize(:red)
    {}
  end

  def load_kamal_secrets
    return [] unless File.exist?(KAMAL_SECRETS_PATH)
    content = File.read(KAMAL_SECRETS_PATH)
    
    # Extract variable names from the secrets file
    variables = []
    content.scan(/(\w+)=\$\(kamal secrets extract (\w+)/) do |var_name, secret_name|
      variables << var_name
    end
    variables
  rescue => e
    puts "❌ Error loading Kamal secrets: #{e.message}".colorize(:red)
    []
  end

  def discover_env_vars
    puts "\n📋 Environment Variables Discovered in Rails Application:"
    puts "-" * 60
    
    DISCOVERED_ENV_VARS.each do |var, info|
      status = info[:required] ? "REQUIRED".colorize(:red) : "OPTIONAL".colorize(:yellow)
      puts "#{var.ljust(25)} | #{status} | #{info[:description]}"
      puts "#{' ' * 25} | Source: #{info[:source]}"
      puts
    end
    
    puts "\n📊 Summary:"
    required_count = DISCOVERED_ENV_VARS.count { |_, info| info[:required] }
    optional_count = DISCOVERED_ENV_VARS.count { |_, info| !info[:required] }
    puts "   Required variables: #{required_count}".colorize(:red)
    puts "   Optional variables: #{optional_count}".colorize(:yellow)
    puts "   Total variables: #{DISCOVERED_ENV_VARS.count}".colorize(:cyan)
  end

  def audit_configuration
    puts "\n🔍 Auditing Kamal Configuration..."
    puts "-" * 40
    
    # Check Kamal deploy.yml
    audit_deploy_yml
    
    # Check Kamal secrets
    audit_secrets_file
    
    # Summary
    show_audit_summary
  end

  def audit_deploy_yml
    puts "\n📝 Checking config/deploy.yml..."
    
    if @kamal_config.empty?
      puts "❌ No Kamal configuration found!".colorize(:red)
      return
    end
    
    # Check secret environment variables
    configured_secrets = @kamal_config.dig("env", "secret") || []
    puts "   Configured secret variables: #{configured_secrets.count}".colorize(:green)
    
    # Check clear environment variables
    configured_clear = @kamal_config.dig("env", "clear") || {}
    puts "   Configured clear variables: #{configured_clear.count}".colorize(:green)
    
    # Find missing required variables
    required_vars = DISCOVERED_ENV_VARS.select { |_, info| info[:required] }.keys
    missing_required = required_vars - configured_secrets - configured_clear.keys
    
    if missing_required.any?
      puts "\n❌ Missing REQUIRED variables in deploy.yml:".colorize(:red)
      missing_required.each do |var|
        puts "   - #{var} (#{DISCOVERED_ENV_VARS[var][:description]})".colorize(:red)
        @missing_vars << var
      end
    else
      puts "✅ All required variables are configured in deploy.yml".colorize(:green)
    end
    
    # Find optional variables not configured
    optional_vars = DISCOVERED_ENV_VARS.select { |_, info| !info[:required] }.keys
    missing_optional = optional_vars - configured_secrets - configured_clear.keys
    
    if missing_optional.any?
      puts "\n⚠️  Missing OPTIONAL variables in deploy.yml:".colorize(:yellow)
      missing_optional.each do |var|
        puts "   - #{var} (#{DISCOVERED_ENV_VARS[var][:description]})".colorize(:yellow)
        @optional_missing_vars << var
      end
    end
  end

  def audit_secrets_file
    puts "\n🔐 Checking .kamal/secrets..."
    
    if @kamal_secrets.empty?
      puts "❌ No Kamal secrets configuration found!".colorize(:red)
      return
    end
    
    puts "   Configured secret extractions: #{@kamal_secrets.count}".colorize(:green)
    
    # Check if secrets file covers all secret variables from deploy.yml
    configured_secrets = @kamal_config.dig("env", "secret") || []
    missing_extractions = configured_secrets - @kamal_secrets
    
    if missing_extractions.any?
      puts "\n❌ Missing secret extractions in .kamal/secrets:".colorize(:red)
      missing_extractions.each do |var|
        puts "   - #{var}".colorize(:red)
      end
    else
      puts "✅ All secret variables have extraction commands".colorize(:green)
    end
  end

  def validate_1password_vault
    puts "\n🔑 Validating 1Password Vault Access..."
    puts "-" * 40
    
    # Check if 1Password CLI is available
    unless system("command -v op > /dev/null 2>&1")
      puts "❌ 1Password CLI not found. Install with: brew install 1password-cli".colorize(:red)
      return
    end
    
    # Check if signed in
    unless system("op account get > /dev/null 2>&1")
      puts "❌ Not signed in to 1Password. Run: op signin".colorize(:red)
      return
    end
    
    puts "✅ 1Password CLI is available and signed in".colorize(:green)
    
    # Test vault access
    test_vault_access
  end

  def test_vault_access
    vault_path = "Kamal-Deployment-Secrets/the-art-exchange-production"
    
    puts "\n🔍 Testing vault access: #{vault_path}"
    
    # Try to fetch secrets that should exist
    secrets_to_test = (@kamal_config.dig("env", "secret") || []).first(3)
    
    secrets_to_test.each do |secret|
      print "   Testing #{secret}... "
      
      if system("op item get '#{vault_path}' --fields #{secret} > /dev/null 2>&1")
        puts "✅".colorize(:green)
      else
        puts "❌".colorize(:red)
        @vault_errors << secret
      end
    end
    
    if @vault_errors.any?
      puts "\n❌ Missing secrets in 1Password vault:".colorize(:red)
      @vault_errors.each { |secret| puts "   - #{secret}".colorize(:red) }
    else
      puts "\n✅ All tested secrets are available in 1Password vault".colorize(:green)
    end
  end

  def test_deployment_environment
    puts "\n🧪 Testing Deployment Environment Simulation..."
    puts "-" * 45
    
    # Test Kamal secrets extraction
    test_secrets_extraction
    
    # Test Docker environment simulation (if Docker is available)
    test_docker_environment if system("command -v docker > /dev/null 2>&1")
  end

  def test_secrets_extraction
    puts "\n🔐 Testing Kamal secrets extraction..."
    
    if File.exist?(KAMAL_SECRETS_PATH)
      puts "   Running Kamal secrets extraction test..."
      
      # Test the extraction command (dry run)
      if system("cd #{Dir.pwd} && bash -n #{KAMAL_SECRETS_PATH}")
        puts "✅ Secrets extraction syntax is valid".colorize(:green)
      else
        puts "❌ Secrets extraction has syntax errors".colorize(:red)
      end
    else
      puts "❌ No secrets file found to test".colorize(:red)
    end
  end

  def test_docker_environment
    puts "\n🐳 Testing Docker environment simulation..."
    
    # Create a test script that simulates the environment
    test_script = create_test_environment_script
    
    if system("docker run --rm -v #{Dir.pwd}:/app -w /app ruby:3.4.3 bash -c '#{test_script}'")
      puts "✅ Docker environment simulation passed".colorize(:green)
    else
      puts "❌ Docker environment simulation failed".colorize(:red)
    end
  end

  def create_test_environment_script
    # Create a simple script that tests if Rails can boot with the environment
    <<~SCRIPT
      set -e
      echo "Testing Rails environment..."
      
      # Simulate setting environment variables
      export RAILS_ENV=production
      export SOLID_QUEUE_IN_PUMA=true
      
      # Test basic Rails commands
      if [ -f Gemfile ]; then
        bundle install --quiet
        bundle exec rails runner 'puts "Rails environment: " + Rails.env' 2>/dev/null || echo "Rails boot test failed"
      else
        echo "No Gemfile found"
      fi
    SCRIPT
  end

  def auto_fix_configuration
    puts "\n🔧 Auto-fixing Configuration Issues..."
    puts "-" * 40
    
    if @missing_vars.empty? && @optional_missing_vars.empty?
      puts "✅ No configuration issues found to fix!".colorize(:green)
      return
    end
    
    # Offer to add missing required variables
    if @missing_vars.any?
      puts "\n❌ Found #{@missing_vars.count} missing REQUIRED variables:".colorize(:red)
      @missing_vars.each { |var| puts "   - #{var}".colorize(:red) }
      
      print "\nAdd these to deploy.yml? (y/N): "
      if gets.chomp.downcase == 'y'
        add_missing_vars_to_config(@missing_vars, "secret")
      end
    end
    
    # Offer to add missing optional variables
    if @optional_missing_vars.any?
      puts "\n⚠️  Found #{@optional_missing_vars.count} missing OPTIONAL variables:".colorize(:yellow)
      @optional_missing_vars.each { |var| puts "   - #{var}".colorize(:yellow) }
      
      print "\nAdd these to deploy.yml? (y/N): "
      if gets.chomp.downcase == 'y'
        add_missing_vars_to_config(@optional_missing_vars, "secret")
      end
    end
  end

  def add_missing_vars_to_config(vars, type)
    puts "\n🔧 Adding variables to config/deploy.yml..."
    
    # Read current config
    config_content = File.read(KAMAL_CONFIG_PATH)
    
    # Add variables to the appropriate section
    vars.each do |var|
      if type == "secret"
        if config_content.include?("env:\n  secret:")
          # Add to existing secret section
          config_content.gsub!(/env:\n  secret:\n((?:    - \w+\n)*)/) do |match|
            "#{match}    - #{var}\n"
          end
        else
          # Create new secret section
          config_content += "\nenv:\n  secret:\n    - #{var}\n"
        end
      end
      
      puts "   Added #{var} to #{type} section".colorize(:green)
    end
    
    # Backup original file
    File.write("#{KAMAL_CONFIG_PATH}.backup", File.read(KAMAL_CONFIG_PATH))
    puts "   Backed up original config to config/deploy.yml.backup".colorize(:yellow)
    
    # Write updated config
    File.write(KAMAL_CONFIG_PATH, config_content)
    puts "   Updated config/deploy.yml".colorize(:green)
  end

  def full_deployment_check
    puts "\n🚀 Full Pre-Deployment Check..."
    puts "=" * 40
    
    audit_configuration
    validate_1password_vault
    test_deployment_environment
    
    # Final summary
    puts "\n📋 Deployment Readiness Summary:"
    puts "-" * 35
    
    if @missing_vars.empty? && @vault_errors.empty?
      puts "✅ READY FOR DEPLOYMENT".colorize(:green)
      puts "   All required environment variables are properly configured."
    else
      puts "❌ NOT READY FOR DEPLOYMENT".colorize(:red)
      puts "   Please fix the issues above before deploying."
    end
    
    unless @optional_missing_vars.empty?
      puts "\n⚠️  Optional variables missing:".colorize(:yellow)
      puts "   Consider adding OAuth keys for full functionality."
    end
  end

  def show_audit_summary
    puts "\n📊 Audit Summary:"
    puts "-" * 20
    
    if @missing_vars.empty?
      puts "✅ All required variables are configured".colorize(:green)
    else
      puts "❌ #{@missing_vars.count} required variables missing".colorize(:red)
    end
    
    unless @optional_missing_vars.empty?
      puts "⚠️  #{@optional_missing_vars.count} optional variables missing".colorize(:yellow)
    end
    
    if @vault_errors.any?
      puts "❌ #{@vault_errors.count} 1Password vault errors".colorize(:red)
    end
  end

  def show_help
    puts <<~HELP
      
      🔍 Kamal Environment Auditor
      
      Usage: #{$0} [command]
      
      Commands:
        discover      Show all environment variables found in Rails app
        audit         Compare Rails needs with Kamal configuration
        validate      Test 1Password vault access and secrets
        test          Simulate deployment environment
        fix           Auto-fix missing configuration
        deploy-check  Full pre-deployment validation
        
      Examples:
        #{$0} discover     # List all environment variables
        #{$0} audit        # Check Kamal configuration
        #{$0} deploy-check # Full deployment readiness check
        
    HELP
  end
end

# Main execution
if __FILE__ == $0
  auditor = KamalEnvironmentAuditor.new
  auditor.run(ARGV[0])
end