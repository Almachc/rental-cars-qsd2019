require 'rails_helper'

feature 'Admin views all car models' do
    scenario 'successfully' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        manufacturer = Manufacturer.create(name: 'Fiat')
        car_category = CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
        CarModel.create!(name: 'ModeloTeste1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')
        CarModel.create!(name: 'ModeloTeste2', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Modelos de carro'

        #Assert
        expect(page).to have_content('ModeloTeste1')
        expect(page).to have_content('ModeloTeste2')
    end

    scenario 'and returns to home page' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Modelos de carro'
       
        click_on 'Voltar'
    
        #Assert
        expect(current_path).to eq root_path
    end

    scenario '(must be authenticated to have access from the menu)' do
        #Act
        visit root_path

        #Assert
        expect(page).to_not have_link('Modelos de carro')
    end

    scenario '(must be authenticated to have access from the url)' do
        #Act
        visit car_models_path

        #Assert
        expect(current_path).to eq new_user_session_path
    end
end