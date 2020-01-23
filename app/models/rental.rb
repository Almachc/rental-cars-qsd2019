class Rental < ApplicationRecord
  belongs_to :client
  belongs_to :car_category
  belongs_to :user
  has_one :car_rental

  validate :start_date_cannot_be_in_the_past, :end_date_must_be_greater_than_start_date

  def start_date_cannot_be_in_the_past
    if start_date.present? && start_date < Date.current
      errors.add(:start_date, "Data inicial não deve estar no passado")
    end
  end

  def end_date_must_be_greater_than_start_date
    if end_date.present? && end_date < start_date
      errors.add(:end_date, "Data final deve ser maior que a data inicial")
    end
  end
end