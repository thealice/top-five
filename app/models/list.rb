class List < ActiveRecord::Base
    belongs_to :user
    has_many :list_items
    belongs_to :category

    validates_presence_of :title
end
