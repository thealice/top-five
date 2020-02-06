class ListItemsController < ApplicationController

  # GET: /list_items
  get "/list_items" do
    erb :"/list_items/index.html"
  end

  # GET: /list_items/new
  get "/list_items/new" do
    erb :"/list_items/new.html"
  end

  # POST: /list_items
  post "/list_items" do
    redirect "/list_items"
  end

  # GET: /list_items/5
  get "/list_items/:id" do
    erb :"/list_items/show.html"
  end

  # GET: /list_items/5/edit
  get "/list_items/:id/edit" do
    erb :"/list_items/edit.html"
  end

  # PATCH: /list_items/5
  patch "/list_items/:id" do
    redirect "/list_items/:id"
  end

  # DELETE: /list_items/5/delete
  delete "/list_items/:id/delete" do
    redirect "/list_items"
  end
end
