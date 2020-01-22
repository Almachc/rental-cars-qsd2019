class CarsController < ApplicationController
    def index
    end

    def new
        @car = Car.new
        @car_models = CarModel.all
        @status_array = Car.statuses_in_pt.to_a
    end

    def show
        @car = Car.find(params[:id])

    end

    def create
        @car = Car.new(cars_params)
        if @car.save!
            flash[:notice] = 'Carro registrado com sucesso'
            redirect_to @car
        else  
            #render
        end
    end

    private

    def cars_params
        params.require(:car).permit(:license_plate, :color, :car_model_id, :mileage, :status)
    end
end