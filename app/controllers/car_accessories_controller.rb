class CarAccessoriesController < ApplicationController
  def index
  end

  def show
    @car_accessory = CarAccessory.find(params[:id])
  end

  def new
    @car_accessory = CarAccessory.new
  end

  def create 
    @car_accessory = CarAccessory.new(car_accessory_params)
    if @car_accessory.save
      flash[:notice] = 'Acessório registrado com sucesso'
      redirect_to @car_accessory
    else 
      #render :new
    end
  end

  private

  def car_accessory_params
    params.require(:car_accessory).permit(:name, :description, :daily_rate, :photo)
  end
end