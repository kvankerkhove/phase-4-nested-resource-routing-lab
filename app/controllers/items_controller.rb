class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_response

  def index
    if params[:user_id]
      items = find_user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    item = find_item
    render json: item, include: :user
  end

  def create
    user = find_user
    new_item = user.items.create!(item_params)
    render json: new_item, include: :user, status: 201
  end

  private
  
  def find_user
    User.find(params[:user_id])
  end

  def find_item
    Item.find(params[:id])
  end

  def item_params
    params.permit(:name, :description, :price, :user_id)
  end

  def render_not_found_response
    render json: { error: "Item not found" }, status: :not_found
  end

  def render_invalid_response
    render json: { error: "Invalid Response" }, status: 422
  end

end
