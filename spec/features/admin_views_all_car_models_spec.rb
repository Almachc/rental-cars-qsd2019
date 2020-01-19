require 'rails_helper'

feature 'Admin views all car models' do
    scenario 'successfully' do
        #Arrange
        manufacturer = Manufacturer.create(name: 'Fiat')
        car_category = CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
        CarModel.create!(name: 'ModeloTeste1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')
        CarModel.create!(name: 'ModeloTeste2', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')

        #Act
        visit root_path
        click_on 'Modelos de carro'

        #Assert
        expect(page).to have_content('ModeloTeste1')
        expect(page).to have_content('ModeloTeste2')
    end

    scenario 'and returns to home page' do
        #Act
        visit root_path
        click_on 'Modelos de carro'
       
        click_on 'Voltar'
    
        #Assert
        expect(current_path).to eq root_path
    end
end