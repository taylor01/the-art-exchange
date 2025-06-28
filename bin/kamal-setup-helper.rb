#!/usr/bin/env ruby
# frozen_string_literal: true

require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "colorize"
  gem "yaml"
  gem "json"
end

class KamalSetupHelper
  KAMAL_CONFIG_PATH = "config/deploy.yml"
  KAMAL_SECRETS_PATH = ".kamal/secrets"
  
  def initialize
    @kamal_config = load_kamal_config
  end

  def run(command = "help")
    puts "🛠️  Kamal Setup Helper".colorize(:blue)
    puts "=" * 50
    
    case command
    when "init", "--init"
      initialize_1password_integration
    when "test-secrets", "--test-secrets"
      test_secrets_access
    when "update-secrets", "--update-secrets"
      update_secrets_file
    when "validate-rails", "--validate-rails"
      validate_rails_boot
    when "docker-test", "--docker-test"
      test_with_docker
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

  def initialize_1password_integration
    puts "\n🔑 Setting up 1Password Integration..."
    puts "-" * 40
    
    # Check prerequisites
    unless check_prerequisites
      return
    end
    
    # Get vault information
    vault_info = get_vault_info
    return unless vault_info
    
    # Create secrets file
    create_secrets_file(vault_info)
    
    puts "\n✅ 1Password integration setup complete!".colorize(:green)
    puts "   Next steps:"
    puts "   1. Add secrets to your 1Password vault"
    puts "   2. Run: ./bin/kamal-env-audit.rb validate"
    puts "   3. Test deployment with: kamal deploy"
  end

  def check_prerequisites
    checks = [
      { name: "1Password CLI", command: "op --version", install: "brew install 1password-cli" },
      { name: "Kamal", command: "kamal version", install: "gem install kamal" },
      { name: "Docker", command: "docker --version", install: "Install Docker Desktop" }
    ]
    
    all_good = true
    
    checks.each do |check|
      print "   Checking #{check[:name]}... "
      if system("#{check[:command]} > /dev/null 2>&1")
        puts "✅".colorize(:green)
      else
        puts "❌".colorize(:red)
        puts "     Install with: #{check[:install]}".colorize(:yellow)
        all_good = false
      end
    end
    
    # Check 1Password signin
    if all_good
      print "   Checking 1Password signin... "
      if system("op account get > /dev/null 2>&1")
        puts "✅".colorize(:green)
      else
        puts "❌".colorize(:red)
        puts "     Run: op signin".colorize(:yellow)
        all_good = false
      end
    end
    
    all_good
  end

  def get_vault_info
    puts "\n📝 Vault Configuration:"
    
    print "   1Password Account ID (or press Enter for default): "
    account_id = gets.chomp
    account_id = "EDM2HXLJBJBWLAD4MSSMVVEYVQ" if account_id.empty?
    
    print "   Vault Name (or press Enter for default): "
    vault_name = gets.chomp
    vault_name = "Kamal-Deployment-Secrets" if vault_name.empty?
    
    print "   Item Name (or press Enter for default): "
    item_name = gets.chomp
    item_name = "the-art-exchange-production" if item_name.empty?
    
    {
      account_id: account_id,
      vault_path: "#{vault_name}/#{item_name}"
    }
  end

  def create_secrets_file(vault_info)
    puts "\n📄 Creating .kamal/secrets file..."
    
    # Ensure .kamal directory exists
    FileUtils.mkdir_p(".kamal") unless Dir.exist?(".kamal")
    
    # Get required secrets from deploy.yml
    secret_vars = @kamal_config.dig("env", "secret") || []
    
    secrets_content = generate_secrets_content(vault_info, secret_vars)
    
    # Backup existing file
    if File.exist?(KAMAL_SECRETS_PATH)
      File.write("#{KAMAL_SECRETS_PATH}.backup", File.read(KAMAL_SECRETS_PATH))
      puts "   Backed up existing secrets file".colorize(:yellow)
    end
    
    File.write(KAMAL_SECRETS_PATH, secrets_content)
    File.chmod(0700, KAMAL_SECRETS_PATH)  # Make it executable
    
    puts "   Created #{KAMAL_SECRETS_PATH}".colorize(:green)
  end

  def generate_secrets_content(vault_info, secret_vars)
    <<~SECRETS
      # Secrets defined here are available for reference under registry/password, env/secret, builder/secrets,
      # and accessories/*/env/secret in config/deploy.yml. All secrets should be pulled from either
      # password manager, ENV, or a file. DO NOT ENTER RAW CREDENTIALS HERE! This file needs to be safe for git.

      # Extract secrets from 1Password
      SECRETS=$(kamal secrets fetch --adapter 1password --account #{vault_info[:account_id]} --from "#{vault_info[:vault_path]}" #{secret_vars.join(' ')})
      #{secret_vars.map { |var| "#{var}=$(kamal secrets extract #{var} ${SECRETS})" }.join("\n")}
    SECRETS
  end

  def test_secrets_access
    puts "\n🧪 Testing 1Password Secrets Access..."
    puts "-" * 40
    
    unless File.exist?(KAMAL_SECRETS_PATH)
      puts "❌ No secrets file found. Run: #{$0} init".colorize(:red)
      return
    end
    
    # Source the secrets file and test each variable
    puts "   Testing secret extraction..."
    
    if system("bash -n #{KAMAL_SECRETS_PATH}")
      puts "✅ Secrets file syntax is valid".colorize(:green)
    else
      puts "❌ Secrets file has syntax errors".colorize(:red)
      return
    end
    
    # Test actual secret fetching (if possible without exposing values)
    puts "   Testing 1Password connectivity..."
    if test_1password_connectivity
      puts "✅ 1Password connectivity successful".colorize(:green)
    else
      puts "❌ 1Password connectivity failed".colorize(:red)
    end
  end

  def test_1password_connectivity
    # Extract vault info from secrets file
    content = File.read(KAMAL_SECRETS_PATH)
    
    if content =~ /--account (\w+) --from "([^"]+)"/
      account_id = $1
      vault_path = $2
      
      # Test if we can access the vault
      system("op item get '#{vault_path}' --account #{account_id} > /dev/null 2>&1")
    else
      false
    end
  end

  def update_secrets_file
    puts "\n🔄 Updating Secrets File..."
    puts "-" * 30
    
    # Get current secret variables from deploy.yml
    current_secrets = @kamal_config.dig("env", "secret") || []
    
    if current_secrets.empty?
      puts "❌ No secret variables defined in deploy.yml".colorize(:red)
      return
    end
    
    puts "   Current secret variables: #{current_secrets.join(', ')}".colorize(:cyan)
    
    # Check if secrets file exists and get current variables
    if File.exist?(KAMAL_SECRETS_PATH)
      content = File.read(KAMAL_SECRETS_PATH)
      current_extractions = content.scan(/(\w+)=\$\(kamal secrets extract/).flatten
      
      missing_extractions = current_secrets - current_extractions
      extra_extractions = current_extractions - current_secrets
      
      if missing_extractions.any?
        puts "   Adding missing extractions: #{missing_extractions.join(', ')}".colorize(:green)
        add_missing_extractions(missing_extractions)
      end
      
      if extra_extractions.any?
        puts "   Removing unused extractions: #{extra_extractions.join(', ')}".colorize(:yellow)
        remove_extra_extractions(extra_extractions)
      end
      
      if missing_extractions.empty? && extra_extractions.empty?
        puts "✅ Secrets file is already up to date".colorize(:green)
      end
    else
      puts "❌ No secrets file found. Run: #{$0} init".colorize(:red)
    end
  end

  def add_missing_extractions(variables)
    content = File.read(KAMAL_SECRETS_PATH)
    
    # Add to the SECRETS fetch command
    content.gsub!(/SECRETS=.*/) do |line|
      current_vars = line.scan(/\w+(?=\))/).last || ""
      "#{line.chomp} #{variables.join(' ')}"
    end
    
    # Add extraction commands
    variables.each do |var|
      content += "#{var}=$(kamal secrets extract #{var} ${SECRETS})\n"
    end
    
    File.write(KAMAL_SECRETS_PATH, content)
    puts "   Updated #{KAMAL_SECRETS_PATH}".colorize(:green)
  end

  def remove_extra_extractions(variables)
    content = File.read(KAMAL_SECRETS_PATH)
    
    variables.each do |var|
      content.gsub!(/#{var}=.*\n/, "")
    end
    
    File.write(KAMAL_SECRETS_PATH, content)
    puts "   Cleaned up #{KAMAL_SECRETS_PATH}".colorize(:green)
  end

  def validate_rails_boot
    puts "\n🚀 Validating Rails Application Boot..."
    puts "-" * 40
    
    # Test if Rails can boot with current environment
    puts "   Testing Rails boot with production environment..."
    
    test_commands = [
      "bundle exec rails runner 'puts \"Rails version: #{Rails.version}\"' RAILS_ENV=production",
      "bundle exec rails runner 'puts \"Database: #{ActiveRecord::Base.connection.adapter_name}\"' RAILS_ENV=production",
      "bundle exec rails runner 'puts \"Storage: #{Rails.application.config.active_storage.service}\"' RAILS_ENV=production"
    ]
    
    test_commands.each do |cmd|
      print "     #{cmd.split(' ')[2..4].join(' ')}... "
      
      if system("#{cmd} > /dev/null 2>&1")
        puts "✅".colorize(:green)
      else
        puts "❌".colorize(:red)
      end
    end
  end

  def test_with_docker
    puts "\n🐳 Testing with Docker Environment..."
    puts "-" * 40
    
    # Create a test Dockerfile for environment testing
    test_dockerfile = create_test_dockerfile
    
    puts "   Building test Docker image..."
    if system("docker build -f #{test_dockerfile} -t kamal-env-test . > /dev/null 2>&1")
      puts "✅ Docker build successful".colorize(:green)
      
      puts "   Testing environment in container..."
      if system("docker run --rm kamal-env-test > /dev/null 2>&1")
        puts "✅ Docker environment test passed".colorize(:green)
      else
        puts "❌ Docker environment test failed".colorize(:red)
      end
      
      # Cleanup
      system("docker rmi kamal-env-test > /dev/null 2>&1")
      File.delete(test_dockerfile)
    else
      puts "❌ Docker build failed".colorize(:red)
    end
  end

  def create_test_dockerfile
    dockerfile_content = <<~DOCKERFILE
      FROM ruby:3.4.3
      
      WORKDIR /app
      
      # Copy essential files
      COPY Gemfile* ./
      COPY config/ ./config/
      COPY bin/ ./bin/
      
      # Install dependencies
      RUN bundle install
      
      # Set production environment
      ENV RAILS_ENV=production
      ENV SOLID_QUEUE_IN_PUMA=true
      
      # Test command
      CMD ["bundle", "exec", "rails", "runner", "puts 'Docker environment test passed'"]
    DOCKERFILE
    
    dockerfile_path = "Dockerfile.envtest"
    File.write(dockerfile_path, dockerfile_content)
    dockerfile_path
  end

  def show_help
    puts <<~HELP
      
      🛠️  Kamal Setup Helper
      
      Usage: #{$0} [command]
      
      Commands:
        init           Set up 1Password integration from scratch
        test-secrets   Test 1Password secrets access
        update-secrets Update secrets file to match deploy.yml
        validate-rails Test Rails application boot
        docker-test    Test environment with Docker
        
      Examples:
        #{$0} init           # Initial 1Password setup
        #{$0} test-secrets   # Test secret access
        #{$0} validate-rails # Test Rails boot
        
    HELP
  end
end

# Main execution
if __FILE__ == $0
  helper = KamalSetupHelper.new
  helper.run(ARGV[0])
end