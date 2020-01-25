class Api::V1::CarsController < Api::V1::ApiController
    def index
        @cars = Car.all  
        render json: @cars, status: :ok
    end

    def show
        @car = Car.find(params[:id])
        render json: @car, status: :ok
    end

    def create
        @car = Car.new(car_params)
        render json: @car, status: :ok if @car.save!
    end

    private
    def car_params
        params.require(:car).permit(:license_plate, :color, :car_model_id, :mileage, :status)
    end
end