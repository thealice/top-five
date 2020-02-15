class List < ActiveRecord::Base
    belongs_to :user
    has_many :list_items
    has_many :list_categories
    has_many :list_categories, through: :list_categories

    validates_presence_of :title
end
