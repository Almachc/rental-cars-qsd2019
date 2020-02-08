require 'rails_helper'

feature 'Admin registers car' do
    scenario 'successfully' do
        #Arrange
        user = create(:user)
        car_model = create(:car_model)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Carros'

        click_on 'Registrar novo carro'

        fill_in 'Placa', with: 'ABC1234'
        fill_in 'Cor', with: 'Branco'
        select 'HB20', from: 'Modelo'
        fill_in 'Quilometragem', with: '200'
        select 'Disponível', from: 'Status'
        click_on 'Enviar'

        #Assert
        expect(Car.count).to eq 1
        car = Car.first
        expect(car).to have_attributes(license_plate: 'ABC1234', car_model: car_model, 
                                       color: 'Branco', mileage: 200, status: 'available')

        expect(current_path).to eq car_path(car)
        
        expect(page).to have_content('Carro registrado com sucesso')
        expect(page).to have_content('ABC1234')
        expect(page).to have_content('Branco')
        expect(page).to have_content('HB20')
        expect(page).to have_content('200')
        expect(page).to have_content('Disponível')
    end
end