class CreateRentals < ActiveRecord::Migration[5.2]
  def change
    create_table :rentals do |t|
      t.string :code
      t.date :start_date
      t.date :end_date
      t.belongs_to :client, foreign_key: true
      t.belongs_to :car_category, foreign_key: true

      t.timestamps
    end
  end
end
