class Manufacturer < ApplicationRecord
  validates :name, presence: {message: 'Nome deve ser preenchido'}, uniqueness: {message: 'Nome deve ser único'}
end
