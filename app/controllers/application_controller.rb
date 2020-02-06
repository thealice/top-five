require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    erb :index
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
