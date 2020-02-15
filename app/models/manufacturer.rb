class Manufacturer < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
