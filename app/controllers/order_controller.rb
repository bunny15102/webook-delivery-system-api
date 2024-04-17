require 'third_party_notifier'
class OrderController < ApplicationController
  before_action :verify_params, only: [:create, :update]

  def create
    @model = Order.new(model_params)
    if @model.save
      send_notification('Create')
      ThirdPartyNotifier.new(@model,'Create').notify
    else
      render json: @model.errors, status: :unprocessable_entity
    end
  end
  
  def update
    @model = Order.find(params[:id])
    if @model.update(model_params)
      send_notification('Update')
    else
      render json: @model.errors, status: :unprocessable_entity
    end
  end

  private
  def model_params
    params.require(:order).permit(:product_name, :status)
  end

  def verify_params
    unless params[:order].present? && params[:order][:product_name].present? && params[:order][:status].present?
      render json: { error: 'Missing parameters' }, status: :unprocessable_entity
    end
  end

  def send_notification(action)
    notifier = ThirdPartyNotifier.new(@model,action)
    if notifier.notify
      render json: { model: @model, message: "Order #{action} successfully, and message notified" }
    else
      Rails.logger.error "Failed to send webhook notification for action: #{action}"
      render json: { model: @model, message: "Order #{action} successfully, but there was an error calling the webhook" }, status: :unprocessable_entity
    end
  end
end
