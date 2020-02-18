require 'rails_helper'

feature 'User views all car rentals' do
    scenario 'successfully' do
        #Arrange (Um mesmo cliente está alugando para o mesmo período dois carros diferentes do
        #mesmo modelo)
        user = create(:user)

        car_model = create(:car_model)
        client = create(:client)

        subsidiary = create(:subsidiary)

        car1 = create(:car, license_plate: 'ABC1234', car_model: car_model, subsidiary: subsidiary)
        car2 = create(:car, license_plate: 'BAR1940', car_model: car_model, subsidiary: subsidiary)

        rental1 = create(:rental, code: 'CIC3301', client: client,
                        car_category: car1.car_model.car_category, user: user)

        rental2 = create(:rental, code: 'JUL1947', client: client,
                        car_category: car2.car_model.car_category, user: user)

        car_rental1 = create(:car_rental, rental: rental1, car: car1)
        car_rental2 = create(:car_rental, rental: rental2, car: car2)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Histórico de serviços prestados'

        #Assert
        expect(current_path).to eq car_rentals_path

        expect(page).to have_content(car_rental1.rental.code)
        expect(page).to have_content(car_rental1.car.license_plate)
        expect(page).to have_content(car_rental1.created_at)
        expect(page).to have_content(car_rental2.rental.code)
        expect(page).to have_content(car_rental2.car.license_plate)
        expect(page).to have_content(car_rental2.car.created_at)
        expect(page).to have_content(client.cpf)
    end

    scenario 'and returns to home page' do
        #Arrange
        user = create(:user)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Histórico de serviços prestados'
    
        click_on 'Voltar'

        #Assert
        expect(current_path).to eq root_path
    end

    scenario '(must be authenticated to have access from the menu)' do
        #Act
        visit root_path

        #Assert
        expect(page).to_not have_link('Histórico de serviços prestados')
    end

    scenario '(must be authenticated to have access from the url)' do
        #Act
        visit car_rentals_path

        #Assert
        expect(current_path).to eq new_user_session_path
    end
end