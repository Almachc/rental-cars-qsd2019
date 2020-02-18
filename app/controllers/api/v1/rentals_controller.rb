class Api::V1::RentalsController < Api::V1::ApiController
    def filter
        client = Client.find_by(cpf: params[:client][:cpf])
        rentals = Rental.where(client: client)
        return render json: rentals, status: :ok if rentals.any?
        render json: { notice: I18n.t(:not_found, scope: [:http_statuses, :messages]) }, status: :not_found
    end
end