class AddCarAccessoryRefToRentals < ActiveRecord::Migration[5.2]
  def change
    add_reference :rentals, :car_accessory, foreign_key: true
  end
end
