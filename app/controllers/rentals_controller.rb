class RentalsController < ApplicationController
    def index

    end

    def show
        @rental = Rental.find(params[:id])
    end

    def search
        @rentals = Rental.where('code LIKE ?', "%#{params[:q].upcase}%")
    end

    def new
        @clients = Client.all 
        @car_categories = CarCategory.all 
        @rental = Rental.new
    end

    def create
        @rental = Rental.new(rental_params)
        @rental.code = SecureRandom.hex(7)
        @rental.user = current_user
        if @rental.save!
            flash[:notice] = 'Locação agendada com sucesso'
            redirect_to @rental
        else  
            #render :edit
        end
    end

    private

    def rental_params
        params.require(:rental).permit(:start_date, :end_date, :client_id, :car_category_id)
    end
end