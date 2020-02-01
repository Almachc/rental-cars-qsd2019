class AddStatusAndDescriptionToRentals < ActiveRecord::Migration[5.2]
  def change
    add_column :rentals, :status, :integer, default: 0
    add_column :rentals, :description, :string
  end
end
