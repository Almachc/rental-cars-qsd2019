class CarAccessory < ApplicationRecord
    has_one_attached :photo
    has_many :rentals
end
