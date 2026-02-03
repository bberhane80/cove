class BookmarksController < ApplicationController
  before_action :authenticate_user!

  # POST /bookmarks
  def create
    @listing = Listing.find(params[:listing_id])
    @bookmark = current_user.bookmarks.build(listing: @listing)
    
    if @bookmark.save
      redirect_to @listing, notice: 'Listing bookmarked!'
    else
      redirect_to @listing, alert: 'Could not bookmark listing.'
    end
  end

  # DELETE /bookmarks/:id
  def destroy
    @bookmark = current_user.bookmarks.find(params[:id])
    @listing = @bookmark.listing
    @bookmark.destroy
    
    redirect_to @listing, notice: 'Bookmark removed.'
  end

  # GET /bookmarks
  def index
    @bookmarks = current_user.bookmarks.includes(:listing).order(created_at: :desc)
  end
end
