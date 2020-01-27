class Api::V1::CarsController < Api::V1::ApiController
    def index
        @cars = Car.all
        return render json: @cars, status: :ok if @cars.any?
        render json: { notice: 'Nenhum carro encontrado' }, status: :not_found
    rescue StandardError
        render json: { notice: 'Ops, algo deu errado no servidor!' }, status: :internal_server_error
    end

    def show
        @car = Car.find(params[:id])
        render json: @car, status: :ok
    rescue ActiveRecord::RecordNotFound
        render json: { notice: 'Carro não encontrado' }, status: :not_found
    rescue StandardError
        render json: { notice: 'Ops, algo deu errado no servidor!' }, status: :internal_server_error
    end

    def create
        @car = Car.new(car_params)
        render json: @car, status: :created if @car.save!
    rescue ActionController::ParameterMissing, ActiveRecord::RecordInvalid
        render json: { notice: 'Campo(s) inválido(s)' }, status: :unprocessable_entity
    rescue StandardError
        render json: { notice: 'Ops, algo deu errado no servidor!' }, status: :internal_server_error
    end

    def update
        @car = Car.find(params[:id])
        render json: @car, status: :ok if @car.update(car_params)
    rescue ActionController::ParameterMissing, ActiveRecord::RecordInvalid
        render json: { notice: 'Campo(s) inválido(s)' }, status: :unprocessable_entity
    rescue StandardError
        render json: { notice: 'Ops, algo deu errado no servidor!' }, status: :internal_server_error
    end

    def destroy
        car = Car.find(params[:id])
        render json: {notice: "Carro de placa '#{car.license_plate}' deletado com sucesso"}, status: :ok if car.destroy
    rescue ActiveRecord::RecordNotFound
        render json: { notice: 'Carro não encontrado' }, status: :not_found
    rescue StandardError
        render json: { notice: 'Ops, algo deu errado no servidor!' }, status: :internal_server_error
    end

    def status
        @car = Car.find(params[:id])
        if @car.update(status: params.require(:status))
            notice = "Carro de placa '#{@car.license_plate}' alterado com sucesso. Seu status agora é: '#{@car.status_in_pt}'"
            render json: {notice: notice}, status: :ok
        end
   
    end

    private

    def car_params
        params.require(:car).permit(:license_plate, :color, :car_model_id, :mileage, :status)
    end


end