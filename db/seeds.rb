# Clear existing data
puts "Clearing existing data..."
Bookmark.destroy_all
Listing.destroy_all
User.destroy_all

puts "Creating sample users..."
# Create test users
user1 = User.create!(
  email: 'test@example.com',
  password: 'password123',
  password_confirmation: 'password123'
)

user2 = User.create!(
  email: 'demo@example.com',
  password: 'password123',
  password_confirmation: 'password123'
)

puts "Creating sample listings..."

# Sample listings data with city and state
listings_data = [
  {
    title: "Luxury Downtown Loft",
    description: "Stunning modern loft in the heart of downtown. Features exposed brick, high ceilings, and floor-to-ceiling windows with city views. Walking distance to restaurants, shops, and public transit. Pet-friendly building with rooftop deck.",
    address: "123 Main Street",
    city: "Chicago",
    state: "IL",
    price: 2500,
    bedrooms: 2,
    bathrooms: 2,
    square_feet: 1200,
    image_url: "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800"
  },
  {
    title: "Cozy Studio Apartment",
    description: "Perfect starter apartment for young professionals. Renovated kitchen with stainless steel appliances, hardwood floors throughout, and in-unit laundry. Close to metro station.",
    address: "456 Elm Avenue",
    city: "Chicago",
    state: "IL",
    price: 1200,
    bedrooms: 0,
    bathrooms: 1,
    square_feet: 500,
    image_url: "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800"
  },
  {
    title: "Spacious Family Home",
    description: "Beautiful 3-bedroom house with large backyard, perfect for families. Updated kitchen, master suite with walk-in closet, and attached 2-car garage. Great school district.",
    address: "789 Oak Street",
    city: "Evanston",
    state: "IL",
    price: 3200,
    bedrooms: 3,
    bathrooms: 2.5,
    square_feet: 2000,
    image_url: "https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=800"
  },
  {
    title: "Modern 1-Bedroom with Balcony",
    description: "Bright and airy apartment with private balcony overlooking the park. Features granite countertops, walk-in closet, and access to building amenities including gym and pool.",
    address: "321 Park Boulevard",
    city: "Chicago",
    state: "IL",
    price: 1800,
    bedrooms: 1,
    bathrooms: 1,
    square_feet: 750,
    image_url: "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800"
  },
  {
    title: "Charming Victorian Apartment",
    description: "Character-filled apartment in historic Victorian building. Original hardwood floors, decorative moldings, and updated kitchen. Pet-friendly building with charm and character.",
    address: "555 Heritage Lane",
    city: "Oak Park",
    state: "IL",
    price: 2100,
    bedrooms: 2,
    bathrooms: 1,
    square_feet: 950,
    image_url: "https://images.unsplash.com/photo-1515263487990-61b07816b324?w=800"
  },
  {
    title: "Waterfront Condo",
    description: "Stunning waterfront views from this luxury condo. Features include marble bathrooms, chef's kitchen, and 24-hour concierge service. Building includes fitness center and rooftop terrace.",
    address: "888 Marina Drive",
    city: "Chicago",
    state: "IL",
    price: 3800,
    bedrooms: 2,
    bathrooms: 2,
    square_feet: 1400,
    image_url: "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800"
  },
  {
    title: "Garden Level Studio",
    description: "Quiet garden-level studio with private patio. Perfect for someone who loves outdoor space. Includes utilities and off-street parking. Ideal for urban gardening enthusiasts.",
    address: "222 Garden Court",
    city: "Naperville",
    state: "IL",
    price: 1100,
    bedrooms: 0,
    bathrooms: 1,
    square_feet: 450,
    image_url: "https://images.unsplash.com/photo-1536376072261-38c75010e6c9?w=800"
  },
  {
    title: "Penthouse Suite",
    description: "Luxurious penthouse with panoramic city views. Features include gourmet kitchen, spa-like master bath, private elevator access, and wraparound terrace. The ultimate in luxury living.",
    address: "999 Skyline Tower",
    city: "Chicago",
    state: "IL",
    price: 5500,
    bedrooms: 3,
    bathrooms: 3,
    square_feet: 2500,
    image_url: "https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800"
  },
  {
    title: "Renovated Brownstone Apartment",
    description: "Beautifully renovated apartment in classic brownstone. High ceilings, original details preserved, modern amenities. Close to cafes and boutiques. Historic charm meets modern convenience.",
    address: "444 Brownstone Row",
    city: "Chicago",
    state: "IL",
    price: 2400,
    bedrooms: 2,
    bathrooms: 1.5,
    square_feet: 1100,
    image_url: "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800"
  },
  {
    title: "Student-Friendly 4-Bedroom",
    description: "Perfect for students or roommates! Four equal-sized bedrooms, two full baths, large living area, and included washer/dryer. Close to campus and bus lines. Utilities included.",
    address: "777 College Avenue",
    city: "Evanston",
    state: "IL",
    price: 2800,
    bedrooms: 4,
    bathrooms: 2,
    square_feet: 1600,
    image_url: "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800"
  },
  {
    title: "Industrial Loft with Exposed Beams",
    description: "Converted warehouse loft with soaring ceilings and exposed wooden beams. Open floor plan perfect for entertaining. Includes dedicated workspace area and bike storage.",
    address: "101 Factory Street",
    city: "Chicago",
    state: "IL",
    price: 2200,
    bedrooms: 1,
    bathrooms: 1,
    square_feet: 1000,
    image_url: "https://images.unsplash.com/photo-1567767292278-a4f21aa2d36e?w=800"
  },
  {
    title: "Suburban Townhouse",
    description: "Three-story townhouse with finished basement. Attached garage, private backyard, and updated appliances throughout. Community includes pool and playground.",
    address: "234 Maple Lane",
    city: "Schaumburg",
    state: "IL",
    price: 2900,
    bedrooms: 3,
    bathrooms: 2.5,
    square_feet: 1800,
    image_url: "https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=800"
  },
  {
    title: "Affordable 2-Bedroom Near Transit",
    description: "Budget-friendly option steps from the metro. Recently painted, new flooring, and includes heat. Perfect for commuters seeking convenience and affordability.",
    address: "567 Transit Way",
    city: "Chicago",
    state: "IL",
    price: 1400,
    bedrooms: 2,
    bathrooms: 1,
    square_feet: 800,
    image_url: "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800"
  },
  {
    title: "Eco-Friendly Solar Home",
    description: "Energy-efficient home with solar panels and smart home technology. Open concept living, modern finishes, and sustainable materials throughout. Low utility bills guaranteed.",
    address: "890 Green Street",
    city: "Wilmette",
    state: "IL",
    price: 3100,
    bedrooms: 3,
    bathrooms: 2,
    square_feet: 1900,
    image_url: "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800"
  },
  {
    title: "Artist's Warehouse Space",
    description: "Live/work space perfect for artists and creatives. High ceilings, abundant natural light, and dedicated studio area. Vibrant creative community with monthly art walks.",
    address: "345 Canvas Street",
    city: "Chicago",
    state: "IL",
    price: 1900,
    bedrooms: 1,
    bathrooms: 1,
    square_feet: 1100,
    image_url: "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800"
  }
]

listings_data.each do |listing_attrs|
  Listing.create!(listing_attrs)
end

# Create some sample bookmarks
puts "Creating sample bookmarks..."
sample_listings = Listing.limit(5)
sample_listings.each do |listing|
  Bookmark.create!(user: user1, listing: listing)
end

puts "✅ Seed data created successfully!"
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts "Created #{User.count} user(s)"
puts "Created #{Listing.count} listing(s)"
puts "Created #{Bookmark.count} bookmark(s)"
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts "\n🔐 Test User Logins:"
puts "Email: test@example.com"
puts "Password: password123"
puts "\nEmail: demo@example.com"
puts "Password: password123"
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
