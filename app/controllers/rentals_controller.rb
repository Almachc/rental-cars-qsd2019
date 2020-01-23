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
        
        car_category = CarCategory.find(@rental.car_category_id) 

        if cars_available(car_category)
            if @rental.save
                flash[:notice] = 'Locação agendada com sucesso'
                redirect_to @rental
            else  
                @clients = Client.all 
                @car_categories = CarCategory.all 
                render :new
            end
        else
            flash[:notice] = 'Carros indisponíveis para esta categoria'
            @clients = Client.all 
            @car_categories = CarCategory.all 
            render :new
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

    def cars_available(car_category)
        #Pegando todos os carros, a partir de todas models, vinculados a essa categoria
        cars = Car.where(car_model: car_category.car_models)

        #Pegando todas as rentals associadas a essa categoria
        rentals = car_category.rentals.to_a

        #Passando por cada rental e verificando se, com base nas datas, ela pode ser descartada
        rentals.filter! do |rental|
            rental.start_date.between?(@rental.start_date, @rental.end_date) ||
            rental.end_date.between?(@rental.start_date, @rental.end_date)
        end

        #Comparando se o número de carros é maior que o número de rentals (se não for, consequentemente
        #não há carros disponíveis. Caso o número de rentals seja maior, então fodeu, alguém já fez merda)
        cars.length > rentals.length ? true : false
    end
end

 # #Filtrando os carros que estão disponíveis e que serão exibidos no formulário de efetivação
# cars_available = []

# cars.each do |car|
#     cars_available < car if car.status == 'available'
# end