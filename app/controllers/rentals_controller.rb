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
        @car_accessories = CarAccessory.all
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

    def report
        @report = {categories: {}, models: {}, initial_date: params[:initial_date], end_date: params[:end_date]}

        #Total de Locações por categoria em um determinado período
        categories = CarCategory.all.to_a
        categories.each do |category|
            @report[:categories][category.name] = Rental.where(status: 'effective', car_category: category, created_at: params[:initial_date]..params[:end_date]).count
        end

        #Total de Locações por modelo de carro em um determinado período
        models = CarModel.all.to_a
        models.each do |model|
            @report[:models][model.name] = CarRental.where(car: model.cars, created_at: params[:initial_date]..params[:end_date]).count
        end
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