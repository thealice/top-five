require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "auth_t@18NSoJ#407"
  end

  get "/" do
    erb :index
  end

  get "/error" do
    erb :error
  end

  helpers do

    def username_exists?(username)
      !!User.find_by(:username => username)
    end

    def logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= User.find_by(:username => session[:username]) if session[:username]
    end

    def user_owner
      # binding.pry
      @user_owner ||= User.find_by(:id => params[:id]) if params[:id]
    end

    def is_user_owner?
      !!(user_owner == current_user)
    end

    def owned_list
      @owned_list ||= List.find_by(:id => params[:id]) if params[:id]
    end

    def owns_list?
      !!(owned_list.user_id == current_user.id) if session[:username]
    end

    def login(username, password)
      user = User.find_by(:username => username) 
 
      if user && user.authenticate(password)
        session[:username] = user.username
        session[:user_id] = user.id
      else
        redirect to '/login'
      end
      
    end

    def logout!
      session.clear
    end

  end

end
