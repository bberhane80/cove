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
        format.html { redirect_to @listing, notice: 'Listing bookmarked!' }
        format.json { render json: { success: true, bookmark_id: @bookmark.id, message: 'Bookmarked!' }, status: :created }
      else
        format.html { redirect_to @listing, alert: 'Could not bookmark listing.' }
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
      if referer&.include?('bookmarks')
        format.html { redirect_to bookmarks_path, notice: 'Bookmark removed.' }
        format.json { render json: { success: true, message: 'Bookmark removed!', redirect: bookmarks_path }, status: :ok }
      elsif referer&.include?(user_profile_path)
        format.html { redirect_to user_profile_path, notice: 'Bookmark removed.' }
        format.json { render json: { success: true, message: 'Bookmark removed!', redirect: user_profile_path }, status: :ok }
      else
        format.html { redirect_to @listing, notice: 'Bookmark removed.' }
        format.json { render json: { success: true, message: 'Bookmark removed!', redirect: listing_path(@listing) }, status: :ok }
      end
    end
  end
end
