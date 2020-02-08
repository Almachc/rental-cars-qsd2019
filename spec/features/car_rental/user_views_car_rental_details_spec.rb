require 'rails_helper'

feature 'User views car rental details' do
	scenario 'successfully ' do
		#Arrange
		user = create(:user)
		rental = create(:rental, user: user)
		car_rental = create(:car_rental, rental: rental)

		#Act
		login_as(user, scope: :user)
		visit root_path
		click_on 'Histórico de serviços prestados'

		within("tr#car_rental-#{car_rental.id}") do
				click_on 'Visualizar'
		end

		#Assert
		expect(page).to have_content(car_rental.rental.code)
		expect(page).to have_content(car_rental.rental.client.cpf)
		expect(page).to have_content(car_rental.car.full_description)
		expect(page).to have_content(car_rental.start_mileage)
		expect(page).to have_content(car_rental.end_mileage)
		expect(page).to have_content(car_rental.price)
		expect(page).to have_content(car_rental.created_at)
	end

	scenario 'and back to the search page' do
		#Arrange
		user = create(:user)
		rental = create(:rental, user: user)
		car_rental = create(:car_rental, rental: rental)
		
		#Act
		login_as(user, scope: :user)
		visit root_path
		click_on 'Histórico de serviços prestados'

		within("tr#car_rental-#{car_rental.id}") do
				click_on 'Visualizar'
		end

		click_on 'Voltar'

		#Assert
		expect(current_path).to eq(car_rentals_path)
	end

	scenario '(must be authenticated to have access from the url)' do
		#Act
		visit car_rental_path('whatever')

		#Assert
		expect(current_path).to eq(new_user_session_path)
	end
end