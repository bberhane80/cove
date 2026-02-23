class ListingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing, only: [:show]

  # GET /listings
  def index
    @listings = Listing.all.order(created_at: :desc)
    @bookmarked_listing_ids = current_user.bookmarks.pluck(:listing_id)
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
