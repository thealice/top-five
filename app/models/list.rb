class List < ActiveRecord::Base
    belongs_to :user
    has_many :list_items
    belongs_to :category
    
    validates_presence_of :title

    def create_list_item(params)
        params[:list_items].each_with_index do |item, index|
            if item["content"] != ""
                self.list_items.create(:content => params["list_items"][index]["content"], :rank => (index + 1))
            end
        end
    end

end
