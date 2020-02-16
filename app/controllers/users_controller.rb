class UsersController < ApplicationController

  # GET: /users
  get "/users" do
    if logged_in?
      @users = User.all
      @users_by_username_asc = @users.sort_by { |user| user.username }
      erb :"/users/index.html"
    else
      erb :error
    end
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
      session[:username] = @user.username
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
    @user = User.find_by(:username => params[:username])

    if @user && @user.authenticate(params[:password])
      session[:username] = @user.username
      session[:user_id] = @user.id
      redirect to "/users/#{@user.id}"
    else
      @error = "Oops! Please check your login info and try again."
      erb :"/users/login.html"
    end
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
    if logged_in?
      @user = User.find_by(:id => params[:id])
      @user_lists = @user.lists.sort_by {|list| list.title.downcase }
      erb :"/users/show.html"
    else
      erb :error
    end
  end

  # # GET: /users/5/edit - Users can only edit their own user page
  # get "/users/:id/edit" do
  #   if is_user_owner?
  #     @user = User.find_by(:id => params[:id])
  #     erb :"/users/edit.html"
  #   else
  #     redirect to '/error'
  #   end
  # end

  # PATCH: /users/5 
  # patch "/users/:id" do
  #   if is_user_owner?
  #     @user = current_user
  #     if @user.username == params[:username] && @user.authenticate(params[:password])
  #       @user.update(name: params[:name]) if params[:name] != ""
  #       @user.update(info: params[:info]) if params[:info] != ""
  #       redirect to "/users/#{params[:id]}"
  #     else
  #       redirect to '/error'
  #     end
    
  #   else
  #     redirect to "/error"
  #   end
  # end

  # # DELETE: /users/5/delete - Check that delete action is protected 
  # delete "/users/:id/delete" do
  #   redirect "/users"
  # end

end
