class CarCategory < ApplicationRecord
    has_many :car_models
    has_many :rentals

    validates :name, 
        presence: true

    validates :daily_rate,
        presence: true,
        numericality: { greater_than: 0, allow_nil: true}

    validates :car_insurance,
        presence: true,
        numericality: { greater_than: 0, allow_nil: true}
    
    validates :third_party_insurance,
        presence: true,
        numericality: { greater_than: 0, allow_nil: true}

    def total_price
        daily_rate + car_insurance + third_party_insurance
    end
end