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

    def owner
      # binding.pry
      @owner ||= User.find_by(:id => params[:id]) if params[:id]
    end

    def is_owner?
      !!(owner == current_user)
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
