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
      @categories = []
      List.all.each do |list|
        @categories << list.category if list.category && !@categories.include?(list.category)
      end
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
        # Add new list items
        params[:list_items].each_with_index do |item, index|
          if item["content"] != ""
            @list.list_items.create(:content => params["list_items"][index]["content"], :rank => (index + 1))
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

  # GET: Show Individual list based on ID
  get "/lists/:id" do
    @list = List.find_by(id: params[:id])
    erb :"/lists/show.html" 
  end

  # GET: Show form to Edit individual list based on ID - Limited to owner of lists
  get "/lists/:id/edit" do
    if owns_list?
      @list = List.find_by(id: params[:id])
      @list_items = @list.list_items
      if @list_items.count < 10
        @difference = 10 - @list_items.count
      end
      erb :"/lists/edit.html"
    else
      erb :error
    end
  end

  # PATCH: Updates existing list and adds or deletes list items
  patch "/lists/:id" do
    if owns_list? # Check to make sure this list belongs to logged in user
      @list = List.find_by(id: params[:id])
      # Update Title and/or Category
      @list.update(title: params[:title], category: params[:category])
      # Update Existing List Items
      existing_items = @list.list_items
      existing_items.each_with_index do |item, index|  
        if params[:list_items][index]["content"] == "" #Check for blank content
          item.delete #if blank, delete
        else
          item.update(content: params[:list_items][index]["content"]) #if not blank, update
        end
      end
      # Save existing list
      @list.save
      
      # Add new list items IF there are unsaved items in the params
      list_count = @list.list_items.count
      if list_count < 10 && params[:list_items].count > list_count
        params[:list_items].each_with_index do |item, index|
          if item["content"] != "" && !item["rank"] 
            @list.list_items.create(:content => params["list_items"][index]["content"], :rank => (index + 1))
          end
        end
        #Save Updated List with new items, if any
        @list.save
      end
      redirect to "/lists/#{@list.id}"
    else
      redirect to "/error"
    end
  end

  # DELETE: Delete individual list if it belongs to logged in user
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
