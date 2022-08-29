class ItemsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found_response

    def index
        if params[:user_id]
            user = find_user
            items = user.items
        else
            items = Item.all
        end

        render json: items, include: :user
    end

    def show
        item = Item.find(params[:id]) 
        render json: item
    end

    # create an item for a specific user
    # route: POST /users/:user_id/items
    def create
        user = find_user
        # for that user we create the item, ActiveRecord assigns
        # the user_id to the item automatically
        item = user.items.create(item_params)
        render json: item, status: :created
    end

    private

    def find_user
        User.find(params[:user_id])
    end

    def item_params
        params.permit(:name, :description, :price, :user_id)
    end

    def render_record_not_found_response
        render json: {error: "User not found"}, status: :not_found
    end

end
