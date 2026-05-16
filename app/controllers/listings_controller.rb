class ListingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing, only: [:show]

  # GET /listings
  def index
    @bookmarked_listing_ids = current_user.bookmarks.pluck(:listing_id)
    
    if params[:q].present?
      # Use AI search
      search_service = AiListingSearchService.new(params[:q])
      result = search_service.search
      
      @listings = result[:listings]
      @search_explanation = result[:explanation]
      @search_query = params[:q]
    else
      # Default: show all listings
      @listings = Listing.all.order(created_at: :desc)
    end
  end

  # GET /listings/:id
  def show
    @bookmarked = current_user.bookmarks.exists?(listing_id: @listing.id)
  end

  private

  def set_listing
    @listing = Listing.find(params[:id])
  end
end
