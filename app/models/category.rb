class Category < ActiveRecord::Base
    has_many :list_categories
    has_many :lists, through: :list_categories
end
