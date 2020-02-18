class Api::V1::RentalsController < Api::V1::ApiController
    def index
        if params[:client][:cpf]
            client = Client.find_by(cpf: params[:client][:cpf])
            @rentals = Rental.where(client: client)
        else 
            @rentals = Rental.all
        end
        return render json: @rentals, status: :ok if @rentals.any?
        render json: { notice: I18n.t(:not_found, scope: [:http_statuses, :messages]) }, status: :not_found
    end

    def show
        @rental = Rental.find_by(id: params[:id])
        return render json: @rental, status: :ok if !@rental.nil?
        render json: { notice: I18n.t(:not_found, scope: [:http_statuses, :messages]) }, status: :not_found
    end
end