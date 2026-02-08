# 🏡 Cove - AI-Powered Rental Listing Platform

Cove is a modern, full-stack apartment rental platform that helps users discover their perfect home through intelligent search and AI-powered personalized recommendations.

## 🌟 Features

### Core Functionality
- **Browse Listings** - Explore available rental properties with detailed information
- **Smart Search** - Natural language search across titles, descriptions, locations, and amenities
- **User Authentication** - Secure sign-up and login with Devise
- **Bookmark System** - Save favorite listings for easy access
- **User Profiles** - Personalized profiles showing bookmarked properties

### AI-Powered Features
- **Personalized Recommendations** - AI analyzes your bookmarked listings to suggest similar properties
- **Smart Matching** - Machine learning-driven compatibility scores (up to 95% match accuracy)
- **Weekly Email Digests** - Automated mailers with AI-generated recommendations and explanations
- **Natural Language Insights** - AI explains WHY each property matches your preferences

## 🛠️ Tech Stack

**Backend:**
- Ruby 3.x
- Ruby on Rails 7.x
- PostgreSQL

**Frontend:**
- HTML5 / ERB Templates
- CSS3 (Custom styling with Bootstrap 5)
- JavaScript
- Bootstrap Icons

**APIs & Services:**
- Anthropic Claude AI (Recommendation Engine)
- Devise (Authentication)
- ActionMailer (Email notifications)

**Development Tools:**
- Git / GitHub
- Dotenv (Environment variable management)

## 📋 Prerequisites

Before you begin, ensure you have the following installed:
- Ruby 3.0 or higher
- Rails 7.0 or higher
- PostgreSQL 12 or higher
- Node.js and Yarn
- Git

## 🚀 Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/cove.git
cd cove
```

### 2. Install Dependencies
```bash
bundle install
yarn install
```

### 3. Set Up Environment Variables

Create a `.env` file in the root directory:
```bash
# .env
ANTHROPIC_API_KEY=your_anthropic_api_key_here
```

**Get your Anthropic API key:**
1. Sign up at https://console.anthropic.com
2. Navigate to API Keys
3. Create a new key
4. Copy and paste it into your `.env` file

### 4. Set Up the Database
```bash
rails db:create
rails db:migrate
rails db:seed
```

This will create sample listings and test users:
- **Email:** test@example.com | **Password:** password123
- **Email:** demo@example.com | **Password:** password123

### 5. Start the Server
```bash
rails server
```

Visit `http://localhost:3000` in your browser.

## 📚 Usage

### For Users

**Sign Up / Log In**
1. Create an account with a unique username and email
2. Browse available listings
3. Use the search bar to find properties by location, price, or description

**Bookmark Listings**
1. Click the bookmark icon on any listing card
2. View all bookmarks in "My Bookmarks" section
3. Remove bookmarks anytime

**Receive AI Recommendations**
1. Bookmark at least one listing
2. Enable email recommendations in your profile settings
3. Receive weekly personalized suggestions based on your preferences

### For Developers

**Run Tests**
```bash
rails test
```

**Access Rails Console**
```bash
rails console
```

**Send Test Recommendation Email**
```ruby
# In Rails console
user = User.first
RecommendationMailer.weekly_recommendations(user).deliver_now
```

**Manually Trigger Weekly Recommendations**
```bash
rails recommendations:send_weekly
```

## 🗂️ Project Structure
```
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
```

## 🤖 AI Recommendation System

### How It Works

1. **Analysis** - AI analyzes your bookmarked listings for patterns (price range, location, size, amenities)
2. **Matching** - Compares your preferences against all available listings
3. **Ranking** - Generates match scores (0-100%) for each recommendation
4. **Explanation** - AI writes personalized reasons why each property fits your taste
5. **Delivery** - Sends beautifully formatted emails with top 3-5 matches

### Example API Flow
```ruby
# 1. User bookmarks listings
user.bookmarks.create(listing: listing)

# 2. AI service analyzes preferences
service = AiRecommendationService.new(user)
result = service.generate_recommendations

# 3. Mailer sends personalized email
RecommendationMailer.weekly_recommendations(user).deliver_now
```

## 📊 Database Schema

### Users
- `username` (string, unique)
- `email` (string, unique)
- `encrypted_password` (string)
- `receive_recommendations` (boolean)

### Listings
- `title` (string)
- `description` (text)
- `address` (string)
- `city` (string)
- `state` (string)
- `price` (decimal)
- `bedrooms` (integer)
- `bathrooms` (decimal)
- `square_feet` (integer)
- `image_url` (string)

### Bookmarks
- `user_id` (foreign key)
- `listing_id` (foreign key)

## 🎨 Design Philosophy

Cove features a calming, nature-inspired design:
- **Colors:** Forest green gradients, earthy tones
- **Typography:** Clean, modern sans-serif fonts
- **UX:** Mobile-first responsive design
- **Accessibility:** High contrast, semantic HTML

## 🔐 Security

- Passwords encrypted with BCrypt
- API keys stored in environment variables
- CSRF protection enabled
- SQL injection prevention via ActiveRecord

## 🚧 Roadmap

- [ ] Add listing filters (price range, bedrooms, bathrooms)
- [ ] Implement map view with location pins
- [ ] Add image upload for listings
- [ ] Integrate payment processing for featured listings
- [ ] Build messaging system between users and landlords
- [ ] Add reviews and ratings
- [ ] Implement advanced AI search with natural language queries


