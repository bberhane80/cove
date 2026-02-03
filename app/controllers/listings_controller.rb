class ListingsController < ApplicationController
  def index
    matching_listings = Listing.all

    @list_of_listings = matching_listings.order({ :created_at => :desc })

    render({ :template => "listing_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_listings = Listing.where({ :id => the_id })

    @the_listing = matching_listings.at(0)

    render({ :template => "listing_templates/show" })
  end

  def create
    the_listing = Listing.new
    the_listing.user_id = params.fetch("query_user_id")
    the_listing.address = params.fetch("query_address")
    the_listing.details = params.fetch("query_details")
    the_listing.neighborhood = params.fetch("query_neighborhood")
    the_listing.city = params.fetch("query_city")
    the_listing.state = params.fetch("query_state")

    if the_listing.valid?
      the_listing.save
      redirect_to("/listings", { :notice => "Listing created successfully." })
    else
      redirect_to("/listings", { :alert => the_listing.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_listing = Listing.where({ :id => the_id }).at(0)

    the_listing.user_id = params.fetch("query_user_id")
    the_listing.address = params.fetch("query_address")
    the_listing.details = params.fetch("query_details")
    the_listing.neighborhood = params.fetch("query_neighborhood")
    the_listing.city = params.fetch("query_city")
    the_listing.state = params.fetch("query_state")

    if the_listing.valid?
      the_listing.save
      redirect_to("/listings/#{the_listing.id}", { :notice => "Listing updated successfully." } )
    else
      redirect_to("/listings/#{the_listing.id}", { :alert => the_listing.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_listing = Listing.where({ :id => the_id }).at(0)

    the_listing.destroy

    redirect_to("/listings", { :notice => "Listing deleted successfully." } )
  end
end
