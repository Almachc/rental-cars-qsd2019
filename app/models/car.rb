class Car < ApplicationRecord
  belongs_to :car_model

  enum status: { available: 0, unavailable: 5 }

  def full_description
    "#{car_model.manufacturer.name} / #{car_model.name} - #{license_plate} - #{color}"
  end

  def self.statuses_in_pt
    statuses.transform_keys {|index| index == 'available' ? 'Disponível' : 'Indisponível' }
  end

  def status_in_pt
    status == 'available' ? 'Disponível' : 'Indisponível'
  end
end