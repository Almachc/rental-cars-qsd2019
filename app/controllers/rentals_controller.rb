class RentalsController < ApplicationController
    before_action :authenticate_user!

    def index
    end

    def show
        @rental = Rental.find(params[:id])
    end

    def new
        @clients = Client.all 
        @car_categories = CarCategory.all 
        @car_accessories = CarAccessory.all_available
        @rental = Rental.new
    end

    def create
        @rental = Rental.new(rental_params)
        @rental.code = SecureRandom.hex(7)
        @rental.user = current_user
        
        if @rental.ok? && @rental.save
            flash[:notice] = t('.success')
            redirect_to @rental
        else
            #flash[:notice] = t('.unavailable_cars')
            #flash[:notice] = 'Acessório indisponível para a período especificado'
            @clients = Client.all 
            @car_categories = CarCategory.all 
            @car_accessories = CarAccessory.all
            render :new
        end
    end

    def search
        @rentals = Rental.where('code LIKE ?', "%#{params[:q].strip.upcase}%")
        if @rentals.any?
            flash[:notice] = t('.success', count: @rentals.length)
            @rentals
        else
            flash[:alert] = t('.no_results', code: params[:q])
            redirect_to rentals_path
        end
    end

    def start
        @rental = Rental.find(params[:id])
        @cars = Car.where(car_model: @rental.car_category.car_models, status: 'available')
        #@cars = @rental.car_category.cars (fazendo uso de 'has_many :cars, through: :car_models' na model 'CarCategory')
    end

    def cancel
        @rental = Rental.find(params[:id])
        if @rental.cancel(description: params[:description])
            redirect_to rentals_path, notice: t('.success')
        elsif
            flash[:alert] = @rental.errors.full_messages
            redirect_to rental_path(@rental)
        end
    end

    private

    def rental_params
        params.require(:rental).permit(:start_date, :end_date, :client_id, :car_category_id, :car_accessory_id)
    end
end