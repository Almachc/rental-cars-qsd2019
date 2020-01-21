class RentalsController < ApplicationController
    def index

    end

    def show
        @rental = Rental.find(params[:id])
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

    def search
        @rentals = Rental.where('code LIKE ?', "%#{params[:q].upcase}%")
    end

    def start
        @rental = Rental.find(params[:id])
        @cars = Car.where(car_model: @rental.car_category.car_models)
        #@cars = @rental.car_category.cars (fazendo uso de 'has_many :cars, through: :car_models' na model CarCategory)
    end

    private

    def rental_params
        params.require(:rental).permit(:start_date, :end_date, :client_id, :car_category_id)
    end
end