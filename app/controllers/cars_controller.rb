class CarsController < ApplicationController
    def index
    end

    def new
        @car = Car.new
        @car_models = CarModel.all
        @subsidiaries = Subsidiary.all
        @status_array = Car.statuses_internationalized.to_a
    end

    def show
        @car = Car.find(params[:id])

    end

    def create
        @car = Car.new(cars_params)
        if @car.save!
            flash[:notice] = t('.success')
            redirect_to @car
        else  
            #render
        end
    end

    private

    def cars_params
        params.require(:car).permit(:license_plate, :color, :car_model_id, :subsidiary_id, :mileage, :status)
    end
end