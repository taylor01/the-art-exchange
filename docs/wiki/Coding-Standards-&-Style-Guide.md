# Coding Standards & Style Guide

## Overview

The Art Exchange follows **Rails Omakase** coding standards with **RuboCop Rails** configuration. This ensures consistent, readable, and maintainable code across the entire codebase. All code must pass linting checks before being merged.

## Ruby & Rails Standards

### RuboCop Configuration
We use the **Rails Omakase** RuboCop configuration, which provides sensible defaults for Rails applications:

```ruby
# .rubocop.yml
require:
  - rubocop-rails
  - rubocop-performance

inherit_gem:
  rubocop-rails-omakase: rubocop.yml

AllCops:
  TargetRubyVersion: 3.3
  NewCops: enable
  Exclude:
    - 'bin/**/*'
    - 'vendor/**/*'
    - 'node_modules/**/*'
    - 'db/schema.rb'
    - 'db/migrate/*'
```

### Running Code Quality Checks
```bash
# Check code style
bundle exec rubocop

# Auto-fix issues where possible
bundle exec rubocop -A

# Check specific files
bundle exec rubocop app/models/user.rb

# Generate configuration for ignored rules
bundle exec rubocop --auto-gen-config
```

## Code Formatting Standards

### Indentation and Spacing
```ruby
# ✅ Good - 2 space indentation
class User < ApplicationRecord
  has_many :user_posters
  
  def full_name
    "#{first_name} #{last_name}"
  end
end

# ❌ Bad - inconsistent spacing
class User< ApplicationRecord
has_many :user_posters

def full_name
"#{first_name} #{last_name}"
end
end
```

### Line Length
- **Maximum 120 characters per line**
- Break long lines at logical points
- Use proper indentation for continued lines

```ruby
# ✅ Good - Proper line breaking
def create_user_poster_with_validation(user, poster, status, condition, price, notes)
  UserPoster.create!(
    user: user,
    poster: poster,
    status: status,
    condition: condition,
    price_paid: price,
    notes: notes
  )
end

# ❌ Bad - Too long
def create_user_poster_with_validation(user, poster, status, condition, price, notes)
  UserPoster.create!(user: user, poster: poster, status: status, condition: condition, price_paid: price, notes: notes)
end
```

## Naming Conventions

### Variables and Methods
```ruby
# ✅ Good - Snake case, descriptive names
user_poster_count = user.user_posters.count
total_collection_value = calculate_total_value(user.owned_posters)

def find_posters_by_artist(artist_name)
  Poster.joins(:artists).where(artists: { name: artist_name })
end

# ❌ Bad - Unclear names, wrong case
upc = user.user_posters.count
tcv = calculate_total_value(user.owned_posters)

def findPostersByArtist(artistName)
  # Implementation
end
```

### Constants and Classes
```ruby
# ✅ Good - Proper constant naming
class PosterMetadataService
  DEFAULT_ANALYSIS_VERSION = '1.2'
  MAX_RETRY_ATTEMPTS = 3
  
  VALID_CONDITIONS = %w[mint excellent good fair poor].freeze
end

# ❌ Bad - Inconsistent naming
class posterMetadataService
  default_analysis_version = '1.2'
  Max_Retry_Attempts = 3
end
```

## Method and Class Organization

### Method Structure
```ruby
# ✅ Good - Clear, single responsibility
class User < ApplicationRecord
  # Class methods first
  def self.find_by_email_case_insensitive(email)
    where('LOWER(email) = ?', email.downcase).first
  end
  
  # Instance methods grouped logically
  def full_name
    "#{first_name} #{last_name}".strip
  end
  
  def owned_posters_count
    user_posters.owned.count
  end
  
  private
  
  def normalize_email
    self.email = email.downcase.strip if email.present?
  end
end
```

### Class Organization Pattern
```ruby
class ExampleModel < ApplicationRecord
  # 1. Includes and extends
  include Searchable
  extend FriendlyId
  
  # 2. Constants
  VALID_STATUSES = %w[active inactive pending].freeze
  
  # 3. Associations
  belongs_to :user
  has_many :related_models
  
  # 4. Validations
  validates :name, presence: true
  validates :status, inclusion: { in: VALID_STATUSES }
  
  # 5. Callbacks
  before_save :normalize_data
  after_create :send_notification
  
  # 6. Scopes
  scope :active, -> { where(status: 'active') }
  
  # 7. Class methods
  def self.find_by_name(name)
    where(name: name).first
  end
  
  # 8. Instance methods
  def display_name
    name.titleize
  end
  
  private
  
  # 9. Private methods
  def normalize_data
    # Implementation
  end
end
```

## Rails-Specific Standards

### Controller Organization
```ruby
# ✅ Good - RESTful controller structure
class PostersController < ApplicationController
  before_action :set_poster, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  
  def index
    @posters = Poster.includes(:artists, :venue)
                    .search_by_params(search_params)
                    .page(params[:page])
  end
  
  def show
    # @poster set by before_action
  end
  
  private
  
  def set_poster
    @poster = Poster.find(params[:id])
  end
  
  def poster_params
    params.require(:poster).permit(:title, :description, :year, :venue_id)
  end
  
  def search_params
    params.permit(:search, :year, :artist, :venue)
  end
end
```

### View Organization
```erb
<%# ✅ Good - Semantic HTML with clear structure %>
<div class="poster-card bg-white rounded-lg shadow-md overflow-hidden">
  <div class="poster-image">
    <%= image_tag poster_image_url(poster), 
                  alt: poster.title,
                  class: "w-full h-48 object-cover" %>
  </div>
  
  <div class="poster-details p-4">
    <h3 class="text-lg font-semibold text-gray-900">
      <%= link_to poster.title, poster_path(poster), 
                  class: "hover:text-blue-600" %>
    </h3>
    
    <p class="text-sm text-gray-600 mt-1">
      <%= poster.venue.name if poster.venue %>
    </p>
    
    <div class="poster-metadata mt-2">
      <span class="text-xs text-gray-500">
        <%= poster.year if poster.year %>
      </span>
    </div>
  </div>
</div>
```

## Database and Migration Standards

### Migration Best Practices
```ruby
# ✅ Good - Clear, reversible migration
class AddVisualMetadataToPosters < ActiveRecord::Migration[8.0]
  def change
    add_column :posters, :visual_metadata, :json
    add_index :posters, :visual_metadata, using: :gin
  end
end

# ✅ Good - Complex migration with rollback
class CreateUserPostersTable < ActiveRecord::Migration[8.0]
  def up
    create_table :user_posters do |t|
      t.references :user, null: false, foreign_key: true
      t.references :poster, null: false, foreign_key: true
      t.string :status, null: false
      t.string :condition
      t.decimal :price_paid, precision: 8, scale: 2
      t.text :notes
      t.timestamps
    end
    
    add_index :user_posters, [:user_id, :poster_id], unique: true
    add_index :user_posters, :status
  end
  
  def down
    drop_table :user_posters
  end
end
```

### Model Validations
```ruby
# ✅ Good - Comprehensive, clear validations
class Poster < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :year, numericality: { 
    greater_than: 1950, 
    less_than_or_equal_to: -> { Date.current.year + 1 }
  }
  validates :print_run_size, numericality: { 
    greater_than: 0 
  }, allow_nil: true
  
  validate :at_least_one_artist
  
  private
  
  def at_least_one_artist
    errors.add(:artists, 'must have at least one artist') if artists.empty?
  end
end
```

## Testing Standards

### RSpec Style
```ruby
# ✅ Good - Clear, descriptive test structure
RSpec.describe User, type: :model do
  describe 'validations' do
    it 'validates presence of email' do
      user = build(:user, email: nil)
      
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end
    
    it 'validates email uniqueness case-insensitively' do
      create(:user, email: 'test@example.com')
      duplicate_user = build(:user, email: 'TEST@example.com')
      
      expect(duplicate_user).not_to be_valid
    end
  end
  
  describe '#full_name' do
    it 'returns first and last name combined' do
      user = build(:user, first_name: 'John', last_name: 'Smith')
      
      expect(user.full_name).to eq 'John Smith'
    end
    
    it 'handles missing last name gracefully' do
      user = build(:user, first_name: 'John', last_name: nil)
      
      expect(user.full_name).to eq 'John'
    end
  end
end
```

### Factory Patterns
```ruby
# ✅ Good - Flexible, realistic factories
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    terms_accepted_at { 1.day.ago }
    terms_version { 'v1.0' }
    
    trait :admin do
      admin { true }
    end
    
    trait :with_collection do
      after(:create) do |user|
        create_list(:user_poster, 3, user: user)
      end
    end
  end
end
```

## CSS and Frontend Standards

### Tailwind CSS Usage
```erb
<%# ✅ Good - Semantic class organization %>
<div class="poster-grid grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
  <% @posters.each do |poster| %>
    <article class="poster-card group">
      <div class="relative overflow-hidden rounded-lg shadow-md 
                  transition-transform duration-200 
                  group-hover:scale-105">
        <%= image_tag poster_image_url(poster),
                      class: "w-full h-64 object-cover" %>
        
        <div class="absolute inset-0 bg-black bg-opacity-0 
                    group-hover:bg-opacity-20 
                    transition-opacity duration-200">
        </div>
      </div>
      
      <div class="mt-4 space-y-2">
        <h3 class="text-lg font-medium text-gray-900 
                   group-hover:text-blue-600 
                   transition-colors duration-200">
          <%= poster.title %>
        </h3>
      </div>
    </article>
  <% end %>
</div>
```

### JavaScript (Stimulus) Standards
```javascript
// ✅ Good - Clear Stimulus controller
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["search", "results", "loading"]
  static values = { url: String, debounce: Number }
  
  connect() {
    this.timeout = null
    this.debounceValue = this.debounceValue || 300
  }
  
  search() {
    clearTimeout(this.timeout)
    
    this.timeout = setTimeout(() => {
      this.performSearch()
    }, this.debounceValue)
  }
  
  async performSearch() {
    const query = this.searchTarget.value.trim()
    
    if (query.length < 2) {
      this.clearResults()
      return
    }
    
    this.showLoading()
    
    try {
      const response = await fetch(`${this.urlValue}?search=${encodeURIComponent(query)}`)
      const html = await response.text()
      
      this.resultsTarget.innerHTML = html
    } catch (error) {
      console.error('Search failed:', error)
      this.showError()
    } finally {
      this.hideLoading()
    }
  }
  
  clearResults() {
    this.resultsTarget.innerHTML = ''
  }
  
  showLoading() {
    this.loadingTarget.classList.remove('hidden')
  }
  
  hideLoading() {
    this.loadingTarget.classList.add('hidden')
  }
  
  showError() {
    this.resultsTarget.innerHTML = '<p class="text-red-600">Search failed. Please try again.</p>'
  }
}
```

## Security Standards

### Input Validation
```ruby
# ✅ Good - Comprehensive parameter filtering
class PostersController < ApplicationController
  private
  
  def poster_params
    params.require(:poster).permit(
      :title, :description, :year, :print_run_size,
      :venue_id, :band_id, :series_id,
      artist_ids: [],
      images: []
    )
  end
  
  def search_params
    params.permit(:search, :year, :artist, :venue, :page)
          .select { |_, value| value.present? }
  end
end

# ✅ Good - Safe database queries
def find_posters_by_search(query)
  return Poster.none if query.blank?
  
  Poster.search_all(query)
        .includes(:artists, :venue, :band)
        .limit(100)
end
```

### Authentication and Authorization
```ruby
# ✅ Good - Clear authorization patterns
class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  
  private
  
  def ensure_admin!
    redirect_to root_path unless current_user&.admin?
  end
end

# ✅ Good - Secure session management
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  private
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end
end
```

## Performance Standards

### Database Query Optimization
```ruby
# ✅ Good - Efficient queries with includes
def index
  @posters = Poster.includes(:artists, :venue, :band, images_attachments: :blob)
                  .search_by_params(search_params)
                  .page(params[:page])
                  .per(25)
end

# ✅ Good - Scoped queries to avoid N+1
class User < ApplicationRecord
  has_many :user_posters
  has_many :owned_posters, -> { where(user_posters: { status: 'owned' }) },
           through: :user_posters, source: :poster
           
  def owned_posters_with_images
    owned_posters.includes(images_attachments: :blob)
  end
end
```

### Caching Strategies
```ruby
# ✅ Good - Strategic caching
class Poster < ApplicationRecord
  def cache_key_with_version
    super + "-#{images.maximum(:updated_at)&.to_i}"
  end
end

# In views
<% cache @poster do %>
  <%= render 'poster_details', poster: @poster %>
<% end %>
```

## Documentation Standards

### Code Comments
```ruby
# ✅ Good - Meaningful comments for complex logic
class PosterMetadataService
  # Analyzes poster visual characteristics using Claude API
  # Returns structured JSON metadata including visual, thematic, and market data
  #
  # @param poster [Poster] The poster to analyze
  # @return [Hash] Structured metadata hash
  def self.analyze_poster(poster)
    return {} unless poster.images.attached?
    
    # Use first attached image for analysis
    primary_image = poster.images.first
    
    # Send to Claude API for visual analysis
    response = AnthropicService.analyze_image(primary_image)
    
    # Parse and validate response structure
    parse_analysis_response(response)
  end
  
  private
  
  # Validates and normalizes Claude API response
  def self.parse_analysis_response(response)
    # Implementation details...
  end
end
```

### README and Documentation
- **Clear setup instructions** - Step-by-step development environment setup
- **Code examples** - Practical usage examples for complex features
- **API documentation** - Comprehensive endpoint documentation
- **Architecture decisions** - Document significant technical choices

## Error Handling Standards

### Exception Handling
```ruby
# ✅ Good - Specific exception handling
class PosterImageProcessor
  def process_image(image_blob)
    return nil unless image_blob.attached?
    
    begin
      image_blob.variant(resize: "600x800>")
    rescue ActiveStorage::FileNotFoundError => e
      Rails.logger.error "Image file not found: #{e.message}"
      nil
    rescue ActiveStorage::InvariableBlobError => e
      Rails.logger.error "Image processing failed: #{e.message}"
      nil
    rescue StandardError => e
      Rails.logger.error "Unexpected error processing image: #{e.message}"
      Sentry.capture_exception(e) if defined?(Sentry)
      nil
    end
  end
end
```

### Validation Error Messages
```ruby
# ✅ Good - User-friendly error messages
class Poster < ApplicationRecord
  validates :title, presence: { 
    message: "Please provide a title for the poster" 
  }
  validates :year, numericality: { 
    greater_than: 1950,
    less_than_or_equal_to: Date.current.year + 1,
    message: "Year must be between 1950 and #{Date.current.year + 1}"
  }
end
```

## Enforcement and Quality Checks

### Pre-commit Requirements
All code must pass these checks before merge:

```bash
# Run comprehensive quality checks
./bin/checks

# Individual checks that must pass:
bundle exec rspec        # All tests passing
bundle exec rubocop      # Zero linting violations
bundle exec brakeman     # Zero security warnings
bundle exec bundle-audit # Zero dependency vulnerabilities
```

### Editor Configuration
```ruby
# .editorconfig
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

[*.rb]
indent_style = space
indent_size = 2

[*.{js,css,scss}]
indent_style = space
indent_size = 2

[*.{yml,yaml}]
indent_style = space
indent_size = 2
```

---

*These coding standards ensure consistency, readability, and maintainability across The Art Exchange codebase. All team members are expected to follow these guidelines and run quality checks before submitting code.*