class ChangeStartDateAndEndDateFromRentals < ActiveRecord::Migration[5.2]
  def change
    change_column :rentals, :start_date, :datetime
    change_column :rentals, :end_date, :datetime
  end
end
