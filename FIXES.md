# Cove — Prioritized Improvement Plan

## P0 — Critical (Security / Architecture / Broken Patterns)

These issues must be resolved before the project can be considered production-ready or submitted for final evaluation.

---

### P0-1: CSRF Protection Disabled Globally

**File:** `app/controllers/application_controller.rb`

**Problem:** `skip_forgery_protection` disables Rails' Cross-Site Request Forgery protection for the entire application. Every state-changing form action (login, profile update, bookmark creation/deletion) is vulnerable to CSRF attacks.

**Suggested Solution:** Remove `skip_forgery_protection` entirely. Rails + Importmap + Stimulus handles CSRF tokens automatically via the `meta[name=csrf-token]` tag in the layout.

**Example:**
```ruby
# BEFORE (insecure)
class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  skip_forgery_protection  # <-- remove this line
  ...
end

# AFTER (correct)
class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  ...
end
```

For AJAX requests, the Rails UJS and Stimulus AJAX helpers automatically include the CSRF token. If using a custom XHR wrapper like `ajax.js`, include the token manually:

```javascript
// In ajax.js, add to all non-GET requests:
const token = document.querySelector('meta[name="csrf-token"]')?.content;
if (token) xhr.setRequestHeader('X-CSRF-Token', token);
```

---

### P0-2: Open Redirect Allowed via Initializer

**File:** `config/initializers/allow_unsafe_redirects.rb`

**Problem:** This initializer disables Rails' protection against open redirect attacks, allowing user-supplied URLs to be used as redirect destinations without validation.

**Suggested Solution:** Delete this file. If a specific redirect case was broken, fix it explicitly with `redirect_to some_safe_path` rather than disabling the protection globally.

```bash
# Delete the file:
rm config/initializers/allow_unsafe_redirects.rb
```

If you have a redirect that requires an external URL (e.g., OAuth callback), validate it explicitly:
```ruby
# Only redirect to URLs within the application
redirect_to request.referer.start_with?(root_url) ? request.referer : root_path
```

---

### P0-3: CI/CD Pipeline Completely Disabled

**File:** `.github/workflows/ci.yml`

**Problem:** The GitHub Actions workflow exists but every meaningful job (Brakeman security scan, Rubocop linting, RSpec tests, importmap audit) is commented out. Only a placeholder `echo` statement runs. No code quality checks run automatically on any push or PR.

**Suggested Solution:** Uncomment and enable the existing jobs. At minimum, run Brakeman and RSpec on every push.

**Example (`ci.yml`):**
```yaml
name: CI

on: [push, pull_request]

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
        with:
          bundler-cache: true
      - run: bundle exec brakeman --no-pager

  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
        with:
          bundler-cache: true
      - run: bundle exec rubocop --parallel

  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:14
        env:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres
        ports: ['5432:5432']
    env:
      DATABASE_URL: postgres://postgres:postgres@localhost:5432/cove_test
      RAILS_ENV: test
    steps:
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
        with:
          bundler-cache: true
      - run: bundle exec rails db:schema:load
      - run: bundle exec rspec
```

---

### P0-4: Unresolved Merge Conflicts in README.md

**File:** `README.md` — lines 248–257 and 269–289

**Problem:** Raw Git conflict markers (`<<<<<<< HEAD`, `=======`, `>>>>>>> bb-ajax`) are present in the submitted README. This corrupts the documentation and demonstrates incomplete conflict resolution.

**Suggested Solution:** Open `README.md`, locate the conflict markers, choose the correct content for each conflict, and delete the conflict marker lines. Then commit the resolved file.

**Conflict 1 (lines 248–257):** Choose either HEAD (empty) or bb-ajax (the footer text). The bb-ajax version is better — keep it:
```markdown
---

**Built with ❤️ during Discovery Partners Institute Software Developer Apprenticeship**

*Making home hunting smarter, one AI recommendation at a time.* 🏡✨

---
```

**Conflict 2 (lines 269–289):** Similarly, review both sides and keep the Quick Links and database schema content if it's accurate.

---

### P0-5: Rake Tasks Referenced in Schedule Do Not Exist

**File:** `config/schedule.rb` references `rake "recommendations:send_daily"`, `rake "recommendations:send_weekly"`, `rake "recommendations:send_biweekly"`, `rake "recommendations:send_monthly"`

**Problem:** These rake tasks are scheduled via `whenever` but no corresponding `lib/tasks/recommendations.rake` file exists. In production, the cron jobs would fail silently with a `"Don't know how to build task"` error, meaning no recommendation emails would ever be sent.

**Suggested Solution:** Create the rake tasks:

```ruby
# lib/tasks/recommendations.rake
namespace :recommendations do
  desc "Send daily recommendation emails"
  task send_daily: :environment do
    users = User.where(receive_recommendations: true, email_frequency: "daily")
    users.find_each do |user|
      RecommendationMailer.weekly_recommendations(user).deliver_later
    end
    puts "Sent daily recommendations to #{users.count} users"
  end

  desc "Send weekly recommendation emails"
  task send_weekly: :environment do
    users = User.where(receive_recommendations: true, email_frequency: "weekly")
    users.find_each do |user|
      RecommendationMailer.weekly_recommendations(user).deliver_later
    end
    puts "Sent weekly recommendations to #{users.count} users"
  end

  # Add send_biweekly and send_monthly similarly
end
```

---

## P1 — Important (Maintainability / Convention / Cleanliness)

These issues represent Rails convention violations, missed patterns, and code quality problems that affect maintainability and grading.

---

### P1-1: Pundit Installed but Not Used — Authorization Is Manual and Inconsistent

**Files:** `app/controllers/users_controller.rb`, `app/controllers/listings_controller.rb`

**Problem:** Pundit is in the Gemfile but no `app/policies/` directory exists. Authorization in `UsersController` is a hand-rolled `unless @user == current_user` check. `ListingsController` has no authorization at all.

**Suggested Solution:** Implement Pundit policies.

```bash
rails g pundit:install
rails g pundit:policy user
rails g pundit:policy listing
```

```ruby
# app/policies/user_policy.rb
class UserPolicy < ApplicationPolicy
  def show? = true
  def edit? = record == user
  def update? = record == user
end

# app/controllers/users_controller.rb
def edit
  authorize @user
end

def update
  authorize @user
  ...
end
```

Add `include Pundit::Authorization` and `after_action :verify_authorized` to `ApplicationController`.

---

### P1-2: Filter Logic in Controller — Model Scopes Are Defined but Ignored

**File:** `app/controllers/listings_controller.rb` lines 12–27
**File:** `app/models/listing.rb` (scopes already defined)

**Problem:** The controller performs raw `where()` filter chains that duplicate scopes already defined on the `Listing` model. This is a DRY and separation-of-concerns violation.

**Evidence:** `Listing` already defines `scope :by_city` and `scope :by_price_range` — these are never called.

**Suggested Solution:** Use the existing scopes and add missing ones to the model:

```ruby
# app/models/listing.rb — add missing scopes
scope :by_state, ->(state) { where(state: state) if state.present? }
scope :by_max_price, ->(max) { where("price <= ?", max) if max.present? }
scope :by_min_price, ->(min) { where("price >= ?", min) if min.present? }
scope :by_min_bedrooms, ->(beds) { where("bedrooms >= ?", beds.to_i) if beds.present? }
scope :studio, -> { where(bedrooms: 0) }
scope :by_min_bathrooms, ->(baths) { where("bathrooms >= ?", baths) if baths.present? }
scope :by_sqft_range, ->(min, max) { where(square_feet: min..max) if min.present? && max.present? }
scope :search_text, ->(term) {
  where("title ILIKE :t OR description ILIKE :t OR address ILIKE :t OR city ILIKE :t", t: "%#{term}%") if term.present?
}

# app/controllers/listings_controller.rb
def index
  @listings = Listing.all
    .by_city(params[:city])
    .by_state(params[:state])
    .by_max_price(params[:max_price])
    .by_min_price(params[:min_price])
    .by_min_bathrooms(params[:bathrooms])
    .search_text(params[:search])
    .recent
  # bedrooms filter with studio logic:
  if params[:bedrooms].present?
    @listings = params[:bedrooms].downcase == "studio" ? @listings.studio : @listings.by_min_bedrooms(params[:bedrooms])
  end
  ...
end
```

---

### P1-3: Duplicate EMAIL_FREQUENCIES Constant

**File:** `app/models/user.rb`

**Problem:** The `EMAIL_FREQUENCIES` constant is defined twice in the same file (approximately lines 66–72 and 74–80), which would cause a Ruby constant redefinition warning.

**Suggested Solution:** Delete the duplicate block. Keep exactly one definition.

---

### P1-4: No .env.example File

**File:** Repository root (missing)

**Problem:** The application requires `ANTHROPIC_API_KEY` and SMTP credentials, but no `.env.example` file guides new developers on what to configure. This makes local setup impossible without asking the original developer.

**Suggested Solution:** Create `.env.example`:

```bash
# .env.example
# Copy this file to .env and fill in your values
# Never commit .env to version control

# Claude AI
ANTHROPIC_API_KEY=sk-ant-api03-your-key-here

# Database (optional if using defaults)
DATABASE_URL=postgres://localhost/cove_development

# Email (for production)
SMTP_ADDRESS=smtp.gmail.com
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-password

# Rails
SECRET_KEY_BASE=generate-with-rails-secret
```

---

### P1-5: Production Mailer Host Hardcoded to "example.com"

**File:** `config/environments/production.rb`

**Problem:** `config.action_mailer.default_url_options = { host: "example.com" }` — links in emails (e.g., Devise password reset links) will point to `example.com` in production.

**Suggested Solution:**
```ruby
# config/environments/production.rb
config.action_mailer.default_url_options = { host: ENV.fetch("APP_HOST", "your-app.onrender.com") }
```

Also update `app/mailers/application_mailer.rb`:
```ruby
default from: ENV.fetch("MAILER_FROM", "noreply@cove.example.com")
```

---

### P1-6: Unused Gems Bloating the Application

**File:** `Gemfile`

**Problem:** Several gems are installed but not used in the codebase. This adds boot time, maintenance overhead, and creates misleading feature signals.

| Gem | Status |
|-----|--------|
| `ransack` | Installed, not used (manual `where()` used instead) |
| `kaminari` | Installed, not used (no `.page()` call) |
| `pagy` | Installed, not used (duplicate of kaminari) |
| `carrierwave` | Installed, no `mount_uploader` in any model |
| `cloudinary` | Installed, not configured or used |

**Suggested Solution:** Either implement these gems or remove them from the Gemfile. Choose one pagination gem (Kaminari recommended), implement it on `ListingsController#index`, and remove the other.

```ruby
# Remove from Gemfile if not using:
# gem "ransack"
# gem "pagy"
# gem "carrierwave"
# gem "cloudinary"

# Implement Kaminari in listings_controller.rb:
@listings = @listings.page(params[:page]).per(12)
```

---

### P1-7: Setup Instructions Are Broken

**File:** `README.md` lines 56–84

**Problem:** The setup section has broken Markdown — unclosed code blocks, embedded environment variables inside code blocks with text mixed in, and missing critical steps (`rails db:create`, `rails db:migrate`, `rails server`).

**Suggested Solution:** Replace the broken setup section with clear, sequential numbered steps:

```markdown
## Setup

### Prerequisites
- Ruby 3.4.1
- PostgreSQL 14+
- Bundler

### Installation

1. Clone the repository
   ```bash
   git clone https://github.com/bberhane80/cove.git
   cd cove
   ```

2. Install dependencies
   ```bash
   bundle install
   ```

3. Configure environment variables
   ```bash
   cp .env.example .env
   # Edit .env and add your ANTHROPIC_API_KEY
   ```

4. Set up the database
   ```bash
   rails db:create db:migrate db:seed
   ```

5. Start the server
   ```bash
   rails server
   ```

6. Visit http://localhost:3000
```

---

### P1-8: Legacy `password` Column in Users Table

**File:** `db/schema.rb`

**Problem:** The `users` table has a `password` (plain text string) column alongside Devise's `encrypted_password` column. The `password` column appears to be a leftover from an earlier non-Devise implementation. It is never read or written to.

**Suggested Solution:** Create a migration to drop the column:

```bash
rails g migration RemovePasswordFromUsers password:string
rails db:migrate
```

---

## P2 — Polish / UX / Enhancements

These issues improve code quality, user experience, and rubric scoring without being blockers.

---

### P2-1: 540+ Lines of Inline CSS in Landing Page

**File:** `app/views/pages/landing.html.erb`

**Problem:** A massive `<style>` tag containing 540+ lines of CSS lives directly in the view. This violates separation of concerns, is not cacheable by the browser as a separate asset, and makes the view nearly impossible to read.

**Suggested Solution:** Extract to a dedicated stylesheet:

```bash
# Create: app/assets/stylesheets/landing.css
# Move all CSS from the <style> tag into this file
# In landing.html.erb, remove the <style> block
# The styles will be included automatically via the asset pipeline
```

---

### P2-2: Turbo Drive Disabled — Enable Turbo Frames for Key Interactions

**File:** `app/javascript/application.js` line 5

**Problem:** `Turbo.session.drive = false` disables all Turbo Drive navigation, which was likely done to avoid conflicts with existing JavaScript. This also prevents using Turbo Frames for partial page updates.

**Suggested Solution:** Instead of disabling Turbo globally, fix the specific conflict. Then implement Turbo Frames for the listings index filter sidebar:

```erb
<%# app/views/listings/index.html.erb %>
<turbo-frame id="listings-grid">
  <%= render @listings %>
</turbo-frame>
```

```erb
<%# Filter form — target the turbo frame %>
<%= form_with url: listings_path, method: :get, data: { turbo_frame: "listings-grid" } do |f| %>
  ...
<% end %>
```

---

### P2-3: Add Pagination to Listings Index

**File:** `app/controllers/listings_controller.rb`

**Problem:** All listings are returned without pagination. As the dataset grows, this will degrade performance significantly.

**Suggested Solution (using Kaminari):**

```ruby
# app/controllers/listings_controller.rb
@listings = @listings.page(params[:page]).per(12)
```

```erb
<%# app/views/listings/index.html.erb %>
<%= paginate @listings %>
```

---

### P2-4: Implement Pundit Policy for Listings (Read-Only for All Users)

**File:** `app/policies/listing_policy.rb` (create this)

**Problem:** Listing access has no authorization at all. Even if listings are currently public, using Pundit establishes the pattern for future admin-only listing creation.

**Suggested Solution:**
```ruby
# app/policies/listing_policy.rb
class ListingPolicy < ApplicationPolicy
  def index? = true
  def show? = true
  def create? = false
  def update? = false
  def destroy? = false
end
```

---

### P2-5: Add Client-Side Form Validation

**File:** Devise forms, user edit form

**Problem:** No client-side validation provides immediate feedback before form submission. Users must wait for a server round-trip to learn about validation errors.

**Suggested Solution:** Add HTML5 validation attributes to key inputs:

```erb
<%# app/views/devise/registrations/new.html.erb %>
<%= f.email_field :email, required: true, autocomplete: "email" %>
<%= f.text_field :username, required: true, minlength: 3, maxlength: 20,
    pattern: "[a-zA-Z0-9_]+", title: "Letters, numbers, and underscores only" %>
<%= f.password_field :password, required: true, minlength: 6 %>
```

---

### P2-6: Implement Actual Background Job for Recommendations

**File:** `app/jobs/` (create new file)

**Problem:** `ExampleBackgroundJob` is an empty skeleton. The recommendation email system should use ActiveJob for proper retry logic and queue management.

**Suggested Solution:**

```ruby
# app/jobs/send_recommendation_email_job.rb
class SendRecommendationEmailJob < ApplicationJob
  queue_as :default
  retry_on StandardError, wait: 5.minutes, attempts: 3

  def perform(user_id)
    user = User.find(user_id)
    return unless user.receive_recommendations?
    RecommendationMailer.weekly_recommendations(user).deliver_now
  end
end

# lib/tasks/recommendations.rake
task send_weekly: :environment do
  User.where(receive_recommendations: true, email_frequency: "weekly")
      .find_each { |user| SendRecommendationEmailJob.perform_later(user.id) }
end
```

---

### P2-7: Commit Message Conventions

**File:** Git commit history

**Problem:** Commits like `"fixed syntax"`, `"changed button"`, `"Initial plan"` (twice) are not descriptive. Industry standard is imperative-mood, scoped messages that explain WHY.

**Suggested Convention:**
```
feat: add AJAX bookmark toggle with JSON response
fix: resolve duplicate EMAIL_FREQUENCIES constant in User model
refactor: move listing filter logic from controller to model scopes
chore: enable CI workflow jobs in GitHub Actions
```

Consider adopting Conventional Commits format: https://www.conventionalcommits.org/

---

### P2-8: Empty Admin Folder

**File:** `app/views/admin/dashboard/index.html.erb`, no corresponding controller

**Problem:** An admin view template exists with no controller, no route, and no admin authentication. This is dead code.

**Suggested Solution:** Either implement a basic admin dashboard or remove the empty file. If implementing:

```ruby
# config/routes.rb
namespace :admin do
  root to: "dashboard#index"
  resources :listings
  resources :users
end

# app/controllers/admin/base_controller.rb
module Admin
  class BaseController < ApplicationController
    before_action :require_admin!

    private

    def require_admin!
      redirect_to root_path, alert: "Not authorized." unless current_user&.admin?
    end
  end
end
```

This would also earn the Admin Dashboard feature point in the rubric.

---

### P2-9: Add alt Tags to Listing Images

**Files:** `app/views/shared/_listing_card.html.erb`, `app/views/listings/show.html.erb`

**Problem:** Images rendered without `alt` attributes fail accessibility requirements and screen reader support.

**Suggested Solution:**
```erb
<%# In _listing_card.html.erb %>
<%= image_tag listing.image_url, alt: "Photo of #{listing.title} in #{listing.city}, #{listing.state}", class: "card-img-top" %>
```

---

### P2-10: Fix Syntax Error in listing_spec.rb

**File:** `spec/models/listing_spec.rb` line 52

**Problem:** A syntax error exists at the end of the listing spec file, which would cause the entire spec file to fail to parse.

**Suggested Solution:** Open the file, locate line 52, and complete or remove the incomplete line. Then verify with:
```bash
bundle exec rspec spec/models/listing_spec.rb
```

---

## Summary Table

| Priority | Issue | File | Impact |
|----------|-------|------|--------|
| P0 | CSRF protection disabled | `application_controller.rb` | Security vulnerability |
| P0 | Open redirect allowed | `config/initializers/allow_unsafe_redirects.rb` | Security vulnerability |
| P0 | CI/CD completely disabled | `.github/workflows/ci.yml` | No automated quality gates |
| P0 | Unresolved merge conflicts in README | `README.md` | Broken documentation |
| P0 | Rake tasks missing for scheduled jobs | `lib/tasks/` (missing) | Email system fails silently |
| P1 | Pundit not used | `app/controllers/` | Manual auth, inconsistent |
| P1 | Controller ignores model scopes | `listings_controller.rb` | DRY/SoC violation |
| P1 | Duplicate EMAIL_FREQUENCIES constant | `user.rb` | Code quality |
| P1 | No .env.example | Repository root | Onboarding failure |
| P1 | Mailer host hardcoded to example.com | `production.rb` | Broken emails in production |
| P1 | Unused gems (Ransack, Kaminari x2, Carrierwave, Cloudinary) | `Gemfile` | Bloat, misleading |
| P1 | Broken setup instructions | `README.md` | Onboarding failure |
| P1 | Legacy `password` column | `db/schema.rb` | Dead schema |
| P2 | 540+ lines inline CSS | `landing.html.erb` | Maintainability |
| P2 | Turbo disabled | `application.js` | Missing Turbo Frames |
| P2 | No pagination | `listings_controller.rb` | Scalability |
| P2 | No client-side validation | Devise/user forms | UX |
| P2 | Empty background job skeleton | `app/jobs/` | Dead code |
| P2 | Vague commit messages | Git history | Professional standard |
| P2 | Empty admin folder | `app/views/admin/` | Dead code |
| P2 | Missing alt tags on images | View templates | Accessibility |
| P2 | Syntax error in listing_spec.rb | `spec/models/listing_spec.rb:52` | Broken test |
