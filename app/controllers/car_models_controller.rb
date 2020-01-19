class CarModelsController < ApplicationController
    before_action :authenticate_user!
    
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

    def edit
        @car_model = CarModel.find(params[:id])
        @car_categories = CarCategory.all
        @manufacturers = Manufacturer.all
    end

    def create
        @car_model = CarModel.new(car_model_params)
        if @car_model.save
            flash[:notice] = 'Modelo cadastrado com sucesso'
            redirect_to @car_model
        else   
            @car_categories = CarCategory.all
            @manufacturers = Manufacturer.all
            render :new
        end
    end

    def update
        @car_model = CarModel.find(params[:id])
        if @car_model.update(car_model_params)
            flash[:notice] = 'Modelo editado com sucesso'
            redirect_to @car_model
        else
            @car_categories = CarCategory.all
            @manufacturers = Manufacturer.all
            render :edit
        end
    end

    private

    def car_model_params
        params.require(:car_model).permit(:name, :year, :manufacturer_id, :motorization, :car_category_id, :fuel_type)
    end
end