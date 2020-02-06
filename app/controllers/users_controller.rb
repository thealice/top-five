class UsersController < ApplicationController

  # GET: /users
  # get "/users" do
  #   erb :"/users/index.html"
  # end

  # GET: /signup - Load Signup form
  get "/signup" do
    erb :"/users/create_user.html"
  end

  # POST: /signup - Create User
  post "/signup" do
    @username_exists = params[:username] if username_exists?(params[:username])
    @user = User.new(params) if !@username_exists
    if @user && @user.save
      session[:user_id] = user.id
      redirect to '/lists'
    else
      erb :"/users/create_user.html"
      # redirect to '/signup'
    end
  end

  # GET: /users/5
  get "/users/:id" do
    erb :"/users/show.html"
  end

  # GET: /users/5/edit
  get "/users/:id/edit" do
    erb :"/users/edit.html"
  end

  # PATCH: /users/5
  patch "/users/:id" do
    redirect "/users/:id"
  end

  # DELETE: /users/5/delete
  delete "/users/:id/delete" do
    redirect "/users"
  end

  helpers do

    def username_exists?(username)
      !!User.find_by(:username => username)
    end

    def login(username, password)
      user = User.find_by(:username => username) 
 
      if user && user.authenticate(password)
        session[:user_id] = user.id
      else
        redirect "/login"
      end
    end

  end

end
