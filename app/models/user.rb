class User < ActiveRecord::Base
    has_many :lists
    has_many :list_items, through: :lists
end
