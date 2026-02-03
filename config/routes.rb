Rails.application.routes.draw do
 
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
