require 'rails_helper'

feature 'Admin registers car model' do
    scenario 'successfully' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        Manufacturer.create(name: 'Fiat')
        CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Modelos de carro'
        click_on 'Cadastrar novo modelo'
        
        fill_in 'Nome', with: 'ModeloTeste1'
        fill_in 'Ano', with: '2019'
        select 'Fiat', from: 'Fabricante'
        fill_in 'Motorização', with: '50'
        select 'T1', from: 'Categoria'
        fill_in 'Tipo de combustível', with: 'Etanol'

        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Modelo cadastrado com sucesso')
        expect(page).to have_content('ModeloTeste1')
        expect(page).to have_content('2019')
        expect(page).to have_content('Fiat')
        expect(page).to have_content('50')
        expect(page).to have_content('T1')
        expect(page).to have_content('Etanol')
    end

    scenario '(all fields must be filled)' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Modelos de carro'

        click_on 'Cadastrar novo modelo'

        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Nome deve ser preenchido')
        expect(page).to have_content('Ano deve ser preenchido')
        expect(page).to have_content('Fabricante deve ser preenchido')    
        expect(page).to have_content('Motorização deve ser preenchido')
        expect(page).to have_content('Categoria deve ser preenchido')
        expect(page).to have_content('Tipo de combustível deve ser preenchido')
    end

    scenario '(must be authenticated to access the create form)' do
        #Act
        visit new_car_model_path
    
        #Assert
        expect(current_path).to eq new_user_session_path
      end
    
      scenario '(must be authenticated to register it)' do
        #Act
        page.driver.submit :post, car_models_path, {}
    
        #Assert
        expect(current_path).to eq new_user_session_path
      end
end