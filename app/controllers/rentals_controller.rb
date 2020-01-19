class RentalsController < ApplicationController
    def index
    end

    def search
        @rentals = Rental.where('code LIKE ?', "%#{params[:q].upcase}%")
    end
end