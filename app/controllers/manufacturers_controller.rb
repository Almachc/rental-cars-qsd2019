class ManufacturersController < ApplicationController
  before_action :authenticate_user!

  def index
    @manufacturers = Manufacturer.all
  end

  def show
    @manufacturer = Manufacturer.find(params[:id])
  end

  def new
    @manufacturer = Manufacturer.new
  end

  def edit
    @manufacturer = Manufacturer.find(params[:id])
  end

  def create
    @manufacturer = Manufacturer.new(manufacturer_params)
    if @manufacturer.save
      flash[:notice] = t('.success')
      redirect_to @manufacturer
    else
      # flash.now[:alert] = 'Você deve corrigir os seguintes erros'
      render :new
    end
  end

  def update
    @manufacturer = Manufacturer.find(params[:id])
    if @manufacturer.update(manufacturer_params)
      flash[:notice] = t('.success')
      redirect_to @manufacturer
    else
      render :edit
    end
  end

  private

  def manufacturer_params
    params.require(:manufacturer).permit(:name)
  end
end