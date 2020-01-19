class CarModel < ApplicationRecord
  belongs_to :manufacturer
  belongs_to :car_category

  validates :name, presence: { message: 'Nome deve ser preenchido'}
  validates :year, presence: { message: 'Ano deve ser preenchido'}
  validates :manufacturer_id, presence: { message: 'Fabricante deve ser preenchido'}
  validates :motorization, presence: { message: 'Motorização deve ser preenchido'}
  validates :car_category_id, presence: { message: 'Categoria deve ser preenchido'}
  validates :fuel_type, presence: { message: 'Tipo de combustível deve ser preenchido'}
end
