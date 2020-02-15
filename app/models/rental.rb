class Rental < ApplicationRecord
  belongs_to :client
  belongs_to :car_category
  belongs_to :user
  has_one :car_rental

  validate :start_date_cannot_be_in_the_past, :end_date_must_be_greater_than_start_date
  validates :start_date, presence: true
  validates :end_date, presence: true

  enum status: { pending: 0, effective: 5, canceled: 10 }

  def start_date_cannot_be_in_the_past
    if start_date.present? && end_date.present? && start_date < Date.current
      errors.add(:start_date, I18n.t(:cannot_be_in_the_past, scope: [:errors, :messages]))
    end
  end

  def end_date_must_be_greater_than_start_date
    if start_date.present? && end_date.present? && end_date < start_date
      errors.add(:end_date, I18n.t(:greater_than, count: User.human_attribute_name("rental.start_date"), scope: [:errors, :messages]))
    end
  end

  def cars_available?
    cars = Car.where(car_model: car_category.car_models)
    rentals = car_category.rentals.to_a

    rentals.filter! do |rental|
      rental.status != 'canceled' &&
      rental.start_date.between?(start_date, end_date) ||
      rental.end_date.between?(start_date, end_date)
    end

    cars.length > rentals.length
  end

  def cancel(description:)
    if description.empty?
      errors.add(:description, I18n.t(:blank, scope: [:errors, :messages]))
      false
    elsif status != 'pending'
      errors.add(:status, I18n.t(:pending, scope: [:errors, :messages]))
      false
    elsif (start_date - 24.hours).past?
      errors.add(:base, I18n.t(:timed_out, scope: [:errors, :models, :rental, :messages]))
      false
    else
      update(status: 'canceled', description: description)
    end
  end
end