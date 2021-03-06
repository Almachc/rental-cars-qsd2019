class CreateCarModels < ActiveRecord::Migration[5.2]
  def change
    create_table :car_models do |t|
      t.string :name
      t.string :year
      t.belongs_to :manufacturer, foreign_key: true
      t.string :motorization
      t.belongs_to :car_category, foreign_key: true
      t.string :fuel_type

      t.timestamps
    end
  end
end
