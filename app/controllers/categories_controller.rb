class CategoriesController < ApplicationController

  # GET: /categories
  get "/categories" do
    @categories = Category.all.sort_by {|category| category.name.downcase}
    erb :"/categories/index.html"
  end

  # # GET: /categories/5
  # get "/categories/:id" do
  #   erb :"/categories/show.html"
  # end

end
