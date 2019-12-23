class CarCategory < ApplicationRecord
    validates :name, :daily_rate, :car_insurance, :third_party_insurance, presence: {message: 'Todos os campos devem ser preenchidos'}
end