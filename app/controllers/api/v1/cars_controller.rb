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
        render json: @car, status: :created if @car.save!
    end

    def update
        @car = Car.find(params[:id])
        render json: @car, status: :ok if @car.update(car_params)
    end

    def destroy
        car = Car.find(params[:id])
        render json: {notice: "Carro de placa '#{car.license_plate}' deletado com sucesso"}, status: :ok if car.destroy
    end

    def status
        @car = Car.find(params[:id])
        if  @car.update(status: params[:status])
            notice = "Carro de placa '#{@car.license_plate}' alterado com sucesso. Seu status agora é: '#{@car.status_in_pt}'"
            render json: {notice: notice}, status: :ok
        end
    end

    private

    def car_params
        params.require(:car).permit(:license_plate, :color, :car_model_id, :mileage, :status)
    end
end