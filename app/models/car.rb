class Car < ApplicationRecord
  belongs_to :car_model

  enum status: { available: 0, unavailable: 5 }

  def full_description
    "#{car_model.manufacturer.name} / #{car_model.name} - #{license_plate} - #{color}"
  end

  def self.statuses_internationalized
    statuses.transform_keys {|key| key == 'available' ? 
                             Car.human_attribute_name('available') :
                             Car.human_attribute_name('unavailable') }
  end

  def status_internationalized
    status == 'available' ? Car.human_attribute_name("available") :
                            Car.human_attribute_name("unavailable")
  end
end