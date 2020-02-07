class List < ActiveRecord::Base
    belongs_to :user
    has_many :list_items

    validates_presence_of :title
end
