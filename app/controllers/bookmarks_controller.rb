class BookmarksController < ApplicationController
  before_action :authenticate_user!

  # GET /bookmarks
  def index
    @bookmarks = current_user.bookmarks.includes(:listing).order(created_at: :desc)
  end

  # POST /bookmarks
  def create
    @listing = Listing.find(params[:listing_id])
    @bookmark = current_user.bookmarks.build(listing: @listing)
    
    respond_to do |format|
      if @bookmark.save
        format.html { redirect_back fallback_location: listings_path, notice: 'Listing bookmarked!' }
        format.turbo_stream
        format.json { render json: { success: true, bookmark_id: @bookmark.id, message: 'Bookmarked!' }, status: :created }
      else
        format.html { redirect_back fallback_location: listings_path, alert: 'Could not bookmark listing.' }
        format.turbo_stream { render turbo_stream: turbo_stream.replace(dom_id(@listing, :bookmark), partial: 'shared/bookmark_button', locals: { listing: @listing }) }
        format.json { render json: { success: false, errors: @bookmark.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookmarks/:id
  def destroy
    @bookmark = current_user.bookmarks.find(params[:id])
    @listing = @bookmark.listing
    @bookmark.destroy

    referer = request.referer
    user_profile_path = Rails.application.routes.url_helpers.user_path(current_user)

    respond_to do |format|
      format.html { redirect_back fallback_location: listings_path, notice: 'Bookmark removed.' }
      format.turbo_stream
      format.json { render json: { success: true, message: 'Bookmark removed!', redirect: request.referer || listings_path }, status: :ok }
    end
  end
end
