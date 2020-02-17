class AddUnitsToCarAccessories < ActiveRecord::Migration[5.2]
  def change
    add_column :car_accessories, :units, :integer
  end
end
