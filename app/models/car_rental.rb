class CarRental < ApplicationRecord
  belongs_to :rental
  belongs_to :car

  validates :price, presence: { message: 'O preço (baseado no custo atual da categoria) é obrigatório' }
  validates :start_mileage, presence: { message: 'A quilometragem inicial (baseada na quilometragem atual do carro) é obrigatória' }
end