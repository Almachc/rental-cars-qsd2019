require 'rails_helper'

feature 'Admin view car models' do
    scenario 'successfully' do
        #Arrange
        manufacturer = Manufacturer.create(name: 'Fiat')
        car_category = CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
        CarModel.create!(name: 'ModeloTeste1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')

        #Act
        visit root_path
        click_on 'Modelos de carro'
        click_on 'ModeloTeste1'

        #Assert
        expect(page).to have_content('ModeloTeste1')
        expect(page).to have_content('2019')
        expect(page).to have_content(manufacturer.name)
        expect(page).to have_content('50')
        expect(page).to have_content(car_category.name)
        expect(page).to have_content('Etanol')
        expect(page).to have_link('Voltar')
    end

    scenario 'and return to home page' do
        manufacturer = Manufacturer.create(name: 'Fiat')
        car_category = CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
        CarModel.create!(name: 'ModeloTeste1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')
    
        visit root_path
        click_on 'Modelos de carro'
        click_on 'ModeloTeste1'
        click_on 'Voltar'
    
        expect(current_path).to eq root_path
    end
end