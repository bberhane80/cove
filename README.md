cove/
├── app/
│   ├── controllers/      # Request handling
│   ├── models/          # Database models (User, Listing, Bookmark)
│   ├── views/           # ERB templates
│   ├── mailers/         # Email templates
│   ├── services/        # AI recommendation logic
│   └── jobs/            # Background jobs
├── config/
│   ├── routes.rb        # URL routing
│   └── database.yml     # Database configuration
├── db/
│   ├── migrate/         # Database migrations
│   └── seeds.rb         # Sample data
└── lib/
    └── tasks/           # Rake tasks (email scheduler)

# 🏡 Cove - AI-Powered Rental Listing Platform

Cove is a modern, full-stack apartment rental platform that helps users discover their perfect home through intelligent search and AI-powered personalized recommendations.

---

## 🌟 Features

- **Browse Listings:** Explore rental properties with detailed info
- **Smart Search:** Natural language search across titles, descriptions, locations, and amenities
- **User Authentication:** Secure sign-up/login with Devise
- **Bookmark System:** Save favorite listings
- **User Profiles:** Personalized profiles with bookmarks
- **AI Recommendations:** Personalized, explainable suggestions via Anthropic Claude AI
- **Weekly Email Digests:** Automated, AI-powered recommendations
- **Admin Dashboard:** Manage users/listings at `/admin/dashboard`
- **API:** Versioned endpoints under `/api/v1/`
- **Background Jobs:** Asynchronous processing with ActiveJob


---

## 🛠️ Tech Stack

- Ruby 3.x, Rails 7.x, PostgreSQL
- HTML5/ERB, CSS3 (Bootstrap 5), JavaScript
- Devise, ActionMailer, ActionMailbox, Anthropic Claude AI
- RSpec for testing

---

## 🚀 Getting Started

### 1. Clone & Install

```sh
git clone https://github.com/yourusername/cove.git
cd cove
bundle install
yarn install # if using JS packages
```

### 2. Setup Database

```sh
rails db:setup
```

### 3. Run Tests

```sh
bundle exec rspec
```

### 4. Start Server

```sh
bin/dev
# or
rails server
```

---

## 👤 User Flows

### Sign Up / Log In
1. Register with a unique email and password
2. Log in to access personalized features

### Bookmark Listings
1. Click the bookmark icon on any listing
2. View all bookmarks in your profile

### Receive AI Recommendations
1. Bookmark at least one listing
2. Enable email recommendations in your profile
3. Receive weekly personalized suggestions



---

## 🗂️ Project Structure

- `app/controllers/` — Request handling (including API and admin)
- `app/models/` — Database models (User, Listing, Bookmark)
- `app/views/` — ERB templates
- `app/mailers/` — Outbound email templates

- `app/services/` — AI recommendation logic
- `app/jobs/` — Background jobs
- `config/routes.rb` — URL routing

---

## 🔌 API Usage

- All API endpoints are under `/api/v1/`
- Example: `GET /api/v1/base/status` returns `{ status: 'ok', time: ... }`

#### Example: Get Listings
```sh
curl https://your-app.com/api/v1/listings
```

#### Example: Create Bookmark (Authenticated)
```sh
curl -X POST -H "Authorization: Bearer <token>" https://your-app.com/api/v1/bookmarks -d 'listing_id=123'
```

---

## 🛡️ Admin

- Admin dashboard: `/admin/dashboard`
- Only users with `admin: true` can access
- Add users as admins via the Rails console:
    ```ruby
    user = User.find_by(email: 'admin@example.com')
    user.update(admin: true)
    ```

---

## ⚙️ Background Jobs

- Use ActiveJob (e.g., Sidekiq, SolidQueue)
- Example job: `ExampleBackgroundJob`

---



---

## 🧪 Testing

- RSpec for unit, integration, and system tests
- Run with `bundle exec rspec`

---

## 🏗️ Deployment (Render.com)

- Uses `render.yaml` for service definition
- Dockerfile included for container builds
- Set environment variables (e.g., `SECRET_KEY_BASE`, `DATABASE_URL`) in Render dashboard
- Build and start commands: `./bin/render-build.sh`, `./bin/render-start.sh`

---

## 🔐 Security

- Passwords encrypted with BCrypt
- API keys and secrets stored in environment variables
- CSRF protection enabled
- SQL injection prevention via ActiveRecord

---

## 🤝 Contributing

1. Fork the repo and create your branch
2. Write tests for your feature or bugfix
3. Open a pull request with a clear description

---

## 🛠️ Troubleshooting

- Check logs for errors: `log/development.log` or `log/production.log`
- Ensure all ENV variables are set in production
- For email issues, verify your ActionMailer and ActionMailbox provider configs

---

## 📚 Documentation

- See inline code comments and `/docs` (add as needed)
- For questions, open an issue or PR

---
