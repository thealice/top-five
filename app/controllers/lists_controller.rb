class ListsController < ApplicationController

  # GET: /lists
  get "/lists" do
    @lists = List.all
    @list_by_created_desc = @lists.sort_by {|list| list.created_at}.reverse
    erb :"/lists/index.html"
  end

  # GET: /lists/new
  get "/lists/new" do
    if logged_in?
      @items_list = (10.times { '<li><input type="text" name="[list_items][][content]"></li>' })
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
        params[:list_items].each.with_index(1) do |item, index|
          if item["content"] != ""
            @list.list_items.create(:content => params["list_items"][index]["content"], :rank => index)
          end
        end
        @list.save
        @user.lists << @list
        redirect to "/lists/#{@list.id}"
      else
        erb :"/lists/new.html"
      end
    else
      erb :error
    end
  end

  # GET: /lists/5
  get "/lists/:id" do
    @list = List.find_by(id: params[:id])
    erb :"/lists/show.html" 
  end

  # GET: /lists/5/edit - Limited to owner of lists
  get "/lists/:id/edit" do
    if owns_list?
      @list = List.find_by(id: params[:id])
      @list_items = @list.list_items
      erb :"/lists/edit.html"
    else
      erb :error
    end
  end

  # PATCH: /lists/5
  patch "/lists/:id" do
    if owns_list?
      @list = List.find_by(id: params[:id])
      #Update Title and/or Category
      @list.update(title: params[:title], category: params[:category])
      #Update List Items
      @items = @list.list_items
      #Check for blank content. if !blank update, if blank delete
      @items.each_with_index do |item, index|
        if params[:list_items][index]["content"] == ""
          item.delete
        else
          item.update(content: params[:list_items][index]["content"])
        end
      end
      #Save Updated List
      @list.save
      redirect to "/lists/#{@list.id}"
    else
      redirect to "/error"
    end
  end

  # DELETE: /lists/5/delete
  delete "/lists/:id/delete" do
    if owns_list?
      @list = owned_list
      @list.delete
      redirect to "/lists"
    else
      erb :error
    end
  end
end
