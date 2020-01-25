class CarRentalsController < ApplicationController
    def show
        @car_rental = CarRental.find(params[:id])
    end

    def create
        rental = Rental.find(params[:rental_id])
        car = Car.find(params[:car_id]) 
        car_rental = rental.create_car_rental(car_id: params[:car_id],
                                              price: rental.car_category.total_price,
                                              start_mileage: car.mileage)
        if car_rental.save!
            flash[:notice] = 'Locação efetivada com sucesso'
            car.update(status: "unavailable")
            redirect_to car_rental
        else  
            #render
        end           
    end
end