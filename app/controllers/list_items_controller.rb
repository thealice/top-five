class ListItemsController < ApplicationController
    
    
    patch '/lists/:list_id/list_items/:id/edit' do
        if is_owner?

        else

        end
    end

    delete '/lists/:list_id/list_items/:id/delete' do
        if is_owner?

        else

        end
    end

end