class CarCategory < ApplicationRecord
    validates :name, 
        presence: {message: 'Nome deve ser preenchido'}

    validates :daily_rate,
        presence: {message: 'Diária deve ser preenchido'},
        numericality: { greater_than: 0, allow_nil: true, message: 'Diária deve ser maior que zero' }

    validates :car_insurance,
        presence: {message: 'Seguro do carro deve ser preenchido'},
        numericality: { greater_than: 0, allow_nil: true, message: 'Seguro do carro deve ser maior que zero' }
    
    validates :third_party_insurance,
        presence: {message: 'Seguro contra terceiros deve ser preenchido'},
        numericality: { greater_than: 0, allow_nil: true, message: 'Seguro contra terceiros deve ser maior que zero' }
end