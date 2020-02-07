class ListsController < ApplicationController

  # GET: /lists
  get "/lists" do
    @lists = List.all
    erb :"/lists/index.html"
  end

  # GET: /lists/new
  get "/lists/new" do
    if logged_in?
      erb :"/lists/new.html"
    else
      redirect to "/login"
    end
  end

  # POST: /lists
  post "/lists" do
    if logged_in?

      @list = List.new(title: params[:title])
      @user = current_user
      if @list && @list.save
        @list.category = params[:category] if params[:category] != ""
        @list.user_id = current_user.id
        params[:list_items].each_with_index do |item, index|
          if item["content"] != ""
            @list.list_items.create(:content => params["list_items"][index]["content"], :rank => index)
          end
        end
        @list.save
        @user.lists << @list
        redirect to "/users/#{current_user.id}"
      else
        erb :"/lists/new.html"
      end
    else
      erb :error
    end
  end

  # GET: /lists/5
  get "/lists/:id" do
    erb :"/lists/show.html"
  end

  # GET: /lists/5/edit - make sure to limit to owner of lists
  get "/lists/:id/edit" do
    if is_owner?
      @list = List.find_by(id: params[:id])
      erb :"/lists/edit.html"
    else
      erb :error
    end
  end

  # PATCH: /lists/5
  patch "/lists/:id" do
    redirect "/lists/:id"
  end

  # DELETE: /lists/5/delete
  delete "/lists/:id/delete" do
    redirect "/lists"
  end
end
