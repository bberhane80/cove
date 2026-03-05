
# 🏡 Cove - AI-Powered Rental Listing Platform

Cove is a modern, full-stack apartment rental platform that uses artificial intelligence to deliver personalized property recommendations. Built with Ruby on Rails and powered by Anthropic's Claude AI, Cove transforms the apartment hunting experience from overwhelming to empowering.

![Cove Banner](https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=1200&h=300&fit=crop)

## 🌟 Key Features

### Core Functionality
- **Browse Listings** - Explore curated rental properties with detailed information
- **Advanced Filtering** - Filter by city, state, price range, bedrooms, bathrooms, and square footage
- **Smart Search** - Natural language search across titles, descriptions, locations, and amenities
- **User Authentication** - Secure sign-up and login with username/email via Devise
- **Bookmark System** - Save favorite listings for easy access and future reference
- **User Profiles** - Personalized profiles displaying bookmarked properties and preferences

### AI-Powered Features
- **Personalized Recommendations** - AI analyzes bookmarked listings to suggest similar properties
- **Smart Matching** - Machine learning-driven compatibility scores (up to 95% match accuracy)
- **Contextual Understanding** - AI considers user bio, preferences, and behavioral patterns
- **Automated Email Digests** - Weekly/bi-weekly/monthly recommendations delivered via email
- **Natural Language Explanations** - AI explains WHY each property matches user preferences
- **Adaptive Learning** - Recommendations improve as users interact with more listings

### User Experience
- **Responsive Design** - Mobile-first approach with Bootstrap 5
- **AJAX Bookmarking** - Toggle bookmarks without page refresh
- **Toast Notifications** - Real-time feedback for user actions
- **Email Preferences** - Granular control over recommendation frequency (daily, weekly, bi-weekly, monthly)
- **Profile Customization** - Users can add name, bio, and manage email settings

## 🌟 Features

### Core Functionality
- **Browse Listings** - Explore available rental properties with detailed information
- **Smart Search** - Natural language search across titles, descriptions, locations, and amenities
- **User Authentication** - Secure sign-up and login with Devise
- **Bookmark System** - Save favorite listings for easy access
- **User Profiles** - Personalized profiles showing bookmarked properties

### AI-Powered Features

## 🛠️ Tech Stack

**Backend:**
- Ruby 3.4.1
- Ruby on Rails 7.x
- PostgreSQL 14+
- Devise (Authentication)
- ActionMailer (Email delivery)
- Bootstrap Icons 1.11.3


**Development Tools:**
Before you begin, ensure you have the following installed:

- **Ruby** 3.0 or higher
- **Rails** 7.0 or higher
- **PostgreSQL** 12 or higher
- **Node.js** and Yarn
Create a `.env` file in the root directory:
```bash
# .env
ANTHROPIC_API_KEY=sk-ant-api03-your-actual-api-key-here

### 4. Set Up the Database
```bash
# Create database
# Seed with sample data
rails db:seed
```

**Sample Users Created:**
- **Email:** test@example.com | **Username:** testuser | **Password:** password123
- **Email:** demo@example.com | **Username:** demouser | **Password:** password123

### 5. Start the Development Server
```

```bash
# Add to Gemfile
```

Restart the server. Emails will now open automatically in your browser!

cove/

## 📚 Usage Guide

### For End Users

**1. Sign Up / Log In**
- Create an account with a unique username and email
- Use the search bar for natural language queries
- View detailed information including photos, amenities, and location

**3. Bookmark Properties**
- Click the bookmark icon on any listing card
- View all bookmarks in "My Bookmarks" section
- Remove bookmarks anytime

**4. Receive AI Recommendations**
- Bookmark at least one listing to start
- Enable email recommendations in your profile settings
- Choose frequency: daily, weekly, bi-weekly, or monthly
- Receive personalized suggestions based on your preferences

### For Developers

**Run Tests**
```bash
rails test
# or with RSpec (if configured)
rspec
```

**Access Rails Console**
```bash
rails console
```

**Test AI Recommendations Manually**
```ruby
# In Rails console
require 'dotenv/load'

user = User.first
service = AiRecommendationService.new(user)
result = service.generate_recommendations

puts result.inspect
```

**Send Test Recommendation Email**
```ruby
# In Rails console
user = User.first
RecommendationMailer.weekly_recommendations(user).deliver_now
```

**Manually Trigger Recommendation Task**

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Berhane Mussie Berhane**
- GitHub: https://github.com/bberhane80
- LinkedIn: https://www.linkedin.com/in/berhaneberhane/
- Email: berhane896@gmail.com

## 🙏 Acknowledgments

- [Anthropic](https://anthropic.com) - Claude AI API for intelligent recommendations
- [Discovery Partners Institute](https://www.discoverypartners.org/) - Training and mentorship
- [Bootstrap](https://getbootstrap.com/) - UI framework
- [Devise](https://github.com/heartcombo/devise) - Authentication solution
- [Unsplash](https://unsplash.com) - Sample property images

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/yourusername/cove/issues) page
2. Open a new issue with:
	- Detailed description of the problem
	- Steps to reproduce
	- Expected vs actual behavior
	- Screenshots (if applicable)
3. Contact: berhane896@gmail.com

## 🔧 Troubleshooting

### Common Issues

**"Anthropic API key missing" error:**
```bash
# Verify .env file exists
cat .env

# Check if API key is loaded
rails console
puts ENV['ANTHROPIC_API_KEY']
```

**Database connection errors:**
```bash
# Check PostgreSQL is running
sudo service postgresql status

# Reset database
rails db:drop db:create db:migrate db:seed
```

**Asset compilation issues:**
```bash
# Precompile assets
rails assets:precompile

# Clear cache
rails tmp:clear
```

**Email not sending:**
```bash
# Check email configuration in config/environments/development.rb
# Verify Letter Opener is installed
# Check logs: tail -f log/development.log
```

## 🌐 Deployment

### Heroku Deployment
```bash
# Create Heroku app
heroku create your-app-name

# Add PostgreSQL
heroku addons:create heroku-postgresql:mini

# Set environment variables
heroku config:set ANTHROPIC_API_KEY=your-key-here

# Deploy
git push heroku main

# Run migrations
heroku run rails db:migrate

# Seed database
heroku run rails db:seed
```

### Environment Variables for Production
```bash
ANTHROPIC_API_KEY=your-api-key
DATABASE_URL=your-database-url
RAILS_ENV=production
SECRET_KEY_BASE=your-secret-key
SMTP_ADDRESS=smtp.gmail.com
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-password
```

<<<<<<< HEAD
=======
---

**Built with ❤️ during Discovery Partners Institute Software Developer Apprenticeship**

*Making home hunting smarter, one AI recommendation at a time.* 🏡✨

---
>>>>>>> bb-ajax

## 📊 Project Stats

- **Lines of Code:** ~5,000+
- **Models:** 3 (User, Listing, Bookmark)
- **Controllers:** 5
- **Views:** 20+
- **API Integrations:** 1 (Anthropic Claude)
- **Development Time:** 4 weeks
- **Contributors:** 1

<<<<<<< HEAD
=======
---

### Quick Links

- [Live Demo](#) (Add when deployed)
- [API Documentation](#)
- [Changelog](CHANGELOG.md)
- [Contributing Guidelines](CONTRIBUTING.md)

---

**Last Updated:** February 2026
- bio (text, optional)
- receive_recommendations (boolean, default: true)
- email_frequency (string, default: 'weekly')
- created_at (datetime)
- updated_at (datetime)
```
>>>>>>> bb-ajax

### Listings Table
```ruby
- title (string)
- description (text)
- address (string)
- city (string, indexed)
- state (string, indexed)
- price (decimal, indexed)
- bedrooms (integer, indexed)
- bathrooms (decimal)
- square_feet (integer)
- image_url (string)
- created_at (datetime)
- updated_at (datetime)
```

### Bookmarks Table (Join Table)
```ruby
- user_id (foreign key, indexed)
- listing_id (foreign key, indexed)
- created_at (datetime)
- updated_at (datetime)
- unique_index: [user_id, listing_id]
```

## 🎨 Design Philosophy

Cove features a calming, nature-inspired design with a focus on usability:

**Color Palette:**
- Primary: Forest Green (#2d5016, #6b8e23)
- Accents: Light Green (#d1fae5, #a7f3d0)
- Neutrals: Grays (#f9fafb, #6b7280)
- Success: Emerald (#059669)

**Typography:**
- System fonts (San Francisco, Segoe UI, Roboto)
- Clean, modern sans-serif hierarchy

**UX Principles:**
- Mobile-first responsive design
- Instant feedback (AJAX, toast notifications)
- Progressive disclosure (collapsible filters)
- Accessible color contrasts
- Clear call-to-actions

🚧 Roadmap
 Add listing filters (price range, bedrooms, bathrooms)
 Implement map view with location pins
 Add image upload for listings
 Integrate payment processing for featured listings
 Build messaging system between users and landlords
 Add reviews and ratings
 Implement advanced AI search with natural language queries
