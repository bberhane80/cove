Rails.application.routes.draw do
 
  # Routes for the Bookmark resource:

  # CREATE
  post("/insert_bookmark", { :controller => "bookmarks", :action => "create" })

  # READ
  get("/bookmarks", { :controller => "bookmarks", :action => "index" })

  get("/bookmarks/:path_id", { :controller => "bookmarks", :action => "show" })

  # UPDATE

  post("/modify_bookmark/:path_id", { :controller => "bookmarks", :action => "update" })

  # DELETE
  get("/delete_bookmark/:path_id", { :controller => "bookmarks", :action => "destroy" })

  #------------------------------

  # Routes for the Listing resource:

  # CREATE
  post("/insert_listing", { :controller => "listings", :action => "create" })

  # READ
  get("/listings", { :controller => "listings", :action => "index" })

  get("/listings/:path_id", { :controller => "listings", :action => "show" })

  # UPDATE

  post("/modify_listing/:path_id", { :controller => "listings", :action => "update" })

  # DELETE
  get("/delete_listing/:path_id", { :controller => "listings", :action => "destroy" })

  #------------------------------

  # Routes for the User resource:

  # CREATE
  post("/insert_user", { :controller => "users", :action => "create" })

  # READ
  get("/users", { :controller => "users", :action => "index" })

  get("/users/:path_id", { :controller => "users", :action => "show" })

  # UPDATE

  post("/modify_user/:path_id", { :controller => "users", :action => "update" })

  # DELETE
  get("/delete_user/:path_id", { :controller => "users", :action => "destroy" })

  #------------------------------

end
