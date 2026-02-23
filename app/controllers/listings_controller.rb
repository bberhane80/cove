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
    
    # Apply natural language search using AI
    if params[:search].present?
      ai_result = AiListingSearchService.new(params[:search]).search
      if ai_result[:success]
        @listings = ai_result[:listings]
        @ai_explanation = ai_result[:explanation]
      else
        @listings = []
        @ai_explanation = ai_result[:explanation]
      end
    end
    
    # Order results if @listings is a relation
    if @listings.is_a?(ActiveRecord::Relation)
      @listings = @listings.order(created_at: :desc)
    end
    
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
