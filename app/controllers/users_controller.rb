class UsersController < ApplicationController

  # GET: /users
  get "/users" do
    @users = User.all
    @users_by_username_asc = @users.sort_by { |user| user.username }
    erb :"/users/index.html"
  end

  # GET: /signup - Load Signup form
  get "/signup" do
    if !logged_in?
      erb :"/users/create_user.html" 
    else 
      redirect to '/'
    end
  end

  # POST: /signup - Create User
  post "/signup" do
    @username_exists = params[:username] if username_exists?(params[:username])
    @user = User.new(params) if !@username_exists
    if @user && @user.save
      session[:username] = user.username
      redirect to '/lists'
    else
      erb :"/users/create_user.html" # do this rather than redirect to '/signup' to get errors to display
    end
  end

  # GET: /login - Load Login form
  get "/login" do
    if !logged_in?
      erb :"/users/login.html"
    else
      redirect to '/'
    end
  end

  # POST: /login - Log User In
  post "/login" do
    login(params[:username], params[:password])
    redirect to '/lists'
  end

  # GET: /logout - Log User Out
  get '/logout' do
    if logged_in?
      logout!
      redirect to '/login'
    else
      redirect to '/'
    end
  end

  # GET: Display user info and a list of their lists
  get "/users/:id" do
    @user = User.find_by(:id => params[:id])
    erb :"/users/show.html"
  end

  # GET: /users/5/edit - Users can only edit their own user page
  get "/users/:id/edit" do
    if is_owner?
      erb :"/users/edit.html"
    else
      redirect to '/error'
    end
  end

  # # PATCH: /users/5 - Check that delete action is protected 
  # patch "/users/:id" do
  #   redirect "/users/:id"
  # end

  # # DELETE: /users/5/delete
  # delete "/users/:id/delete" do
  #   redirect "/users"
  # end

end
