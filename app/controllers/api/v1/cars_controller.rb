class Api::V1::CarsController < Api::V1::ApiController
    def index
        @cars = Car.all
        return render json: @cars, status: :ok if @cars.any?
        render json: { notice: I18n.t(:not_found, scope: [:http_statuses, :messages]) }, status: :not_found
    end

    def show
        @car = Car.find(params[:id])
        render json: @car, status: :ok
    end

    def create
        @car = Car.new(car_params)
        render json: @car, status: :created if @car.save!
    end

    def update
        @car = Car.find(params[:id])
        render json: @car, status: :ok if @car.update!(car_params)
    end

    def destroy
        car = Car.find(params[:id])
        render json: { notice: I18n.t('success', license_plate: car.license_plate, scope: [:api, :v1, :cars, :destroy]) }, status: :ok if car.destroy
    end

    def status
        @car = Car.find(params[:id])
        if @car.update(status: params.require(:status))
            notice = I18n.t('success', scope: [:api, :v1, :cars, :status])
            render json: { notice: notice }, status: :ok
        end
    end

    private

    def car_params
        params.require(:car).permit(:license_plate, :color, :car_model_id, :mileage, :status)
    end
end