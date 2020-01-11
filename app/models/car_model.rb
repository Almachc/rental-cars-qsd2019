class CarModel < ApplicationRecord
  belongs_to :manufacturer
  belongs_to :car_category

  validates :name, presence: { message: 'Nome não deve ficar em branco'}
  validates :year, presence: { message: 'Ano não deve ficar em branco'}
  validates :manufacturer_id, presence: { message: 'Fabricante não deve ficar em branco'}
  validates :motorization, presence: { message: 'Cavalos não deve ficar em branco'}
  validates :car_category_id, presence: { message: 'Categoria não deve ficar em branco'}
  validates :fuel_type, presence: { message: 'Tipo de combustível não deve ficar em branco'}
end
