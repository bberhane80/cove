class ListingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing, only: [:show]

  def index
    @bookmarked_listing_ids = current_user.bookmarks.pluck(:listing_id)
    
    # Start with all listings
    @listings = Listing.all
    
    # Apply filters
    @listings = @listings.where(city: params[:city]) if params[:city].present?
    @listings = @listings.where(state: params[:state]) if params[:state].present?
    @listings = @listings.where("price <= ?", params[:max_price]) if params[:max_price].present?
    @listings = @listings.where("price >= ?", params[:min_price]) if params[:min_price].present?
    @listings = @listings.where(bedrooms: params[:bedrooms]) if params[:bedrooms].present?
    @listings = @listings.where("bathrooms >= ?", params[:bathrooms]) if params[:bathrooms].present?
    @listings = @listings.where("square_feet >= ?", params[:min_sqft]) if params[:min_sqft].present?
    @listings = @listings.where("square_feet <= ?", params[:max_sqft]) if params[:max_sqft].present?
    
    # Apply search
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @listings = @listings.where(
        "title ILIKE ? OR description ILIKE ? OR address ILIKE ? OR city ILIKE ?", 
        search_term, search_term, search_term, search_term
      )
    end
    
    # Order results
    @listings = @listings.order(created_at: :desc)
    
    # Get unique values for filter dropdowns
    @cities = Listing.distinct.pluck(:city).compact.sort
    @states = Listing.distinct.pluck(:state).compact.sort
  end

  def show
    @bookmark = current_user.bookmarks.find_by(listing_id: @listing.id)
    @bookmarked = @bookmark.present?
  end

  private

  def set_listing
    @listing = Listing.find(params[:id])
  end
end
