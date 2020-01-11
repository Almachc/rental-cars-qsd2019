require 'rails_helper'

feature 'Admin edit car model' do
    scenario 'successfully' do
        #Arrange
        manufacturer = Manufacturer.create(name: 'Fiat')
        car_category = CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
        CarModel.create!(name: 'ModeloTeste1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')
        
        #Act
        visit root_path
        click_on 'Modelos de carro'
        click_on 'ModeloTeste1'
        click_on 'Editar'
        
        fill_in 'Ano', with: '2015'

        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Modelo editado com sucesso')
        expect(page).not_to have_content('2019')
        expect(page).to have_content('2015')
    end

    scenario 'all fields must be filled' do
        #Arrange
        manufacturer = Manufacturer.create(name: 'Fiat')
        car_category = CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
        CarModel.create!(name: 'ModeloTeste1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')
        
        #Act
        visit root_path
        click_on 'Modelos de carro'
        click_on 'ModeloTeste1'
        click_on 'Editar'
        
        fill_in 'Nome', with: ''

        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Nome não deve ficar em branco')
        expect(page).to have_content('Editar modelo')
    end
end