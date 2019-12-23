class CarModelsController < ApplicationController
    def index
        @car_models = CarModel.all
    end

    def show
        @car_model = CarModel.find(params[:id])
    end

    def new
        @car_model = CarModel.new
        @car_categories = CarCategory.all
        @manufacturers = Manufacturer.all
    end

    def create
        @car_model = CarModel.new(params.require(:car_model).permit(:name, :year, :manufacturer_id, :motorization, :car_category_id, :fuel_type))
        if @car_model.save
            flash[:notice] = 'Modelo cadastrado com sucesso'
            redirect_to @car_model
        else   
            #render :new
        end
    end
end