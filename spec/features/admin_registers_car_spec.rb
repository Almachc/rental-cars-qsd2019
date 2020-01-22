require 'rails_helper'

feature 'Admin registers car' do
    scenario 'successfully' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')

        manufacturer = Manufacturer.create(name: 'Fiat')
        car_category = CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
        CarModel.create!(name: 'Modelo1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Carros'

        click_on 'Registrar novo carro'

        fill_in 'Placa', with: 'ABC1234'
        fill_in 'Cor', with: 'Branco'
        select 'Modelo1', from: 'Modelo'
        fill_in 'Quilometragem', with: '200'
        select 'Disponível', from: 'Status'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Carro registrado com sucesso')

        expect(page).to have_content('ABC1234')
        expect(page).to have_content('Branco')
        expect(page).to have_content('Modelo')
        expect(page).to have_content('200')
        expect(page).to have_content('Disponível')
    end
end