class CreateCarAccessories < ActiveRecord::Migration[5.2]
  def change
    create_table :car_accessories do |t|
      t.string :name
      t.string :description
      t.decimal :daily_rate

      t.timestamps
    end
  end
end
