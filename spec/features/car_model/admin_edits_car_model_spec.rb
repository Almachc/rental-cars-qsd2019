require 'rails_helper'

feature 'Admin edits car model' do
    scenario 'successfully' do
        #Arrange
        user = create(:user)
        car_model = create(:car_model, year: '2019')
        
        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Modelos de carro'
        click_on 'HB20'
        click_on 'Editar'
        
        fill_in 'Ano', with: '2015'
        click_on 'Enviar'

        #Assert
        expect(car_model.reload.year).to eq '2015'

        expect(current_path).to eq car_model_path(car_model)

        expect(page).to have_content('Modelo editado com sucesso')
        expect(page).to have_content(car_model.name)
        expect(page).to have_content('2015')
        expect(page).to have_content(car_model.motorization)
        expect(page).to have_content(car_model.fuel_type)
        expect(page).to have_content(car_model.manufacturer.name)
        expect(page).to have_content(car_model.car_category.name)
    end

    scenario '(all fields must be filled)' do
        #Arrange
        user = create(:user)
        create(:car_model)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Modelos de carro'
        click_on 'HB20'
        click_on 'Editar'
        
        fill_in 'Nome', with: ''
        fill_in 'Ano', with: ''
        fill_in 'Motorização', with: ''
        fill_in 'Tipo de combustível', with: ''

        click_on 'Enviar'

        #Assert
        expect(CarModel.first).to_not have_attributes(name: '', year: '', motorization: '',
                                                         fuel_type: '')

        expect(page).to have_field('Nome', with: '')
        expect(page).to have_field('Ano', with: '')
        expect(page).to have_field('Fabricante', with: '1')
        expect(page).to have_field('Motorização', with: '')
        expect(page).to have_field('Categoria de carro', with: '1')
        expect(page).to have_field('Tipo de combustível', with: '')

        expect(page).to have_content('Nome não pode ficar em branco')
        expect(page).to have_content('Ano não pode ficar em branco')
        expect(page).to have_content('Motorização não pode ficar em branco')
        expect(page).to have_content('Tipo de combustível não pode ficar em branco')
        #expect(page).to have_content('Fabricante é obrigatório(a)')
        #expect(page).to have_content('Categoria é obrigatório(a)')
    end

    scenario '(must be authenticated to have access to the edit form)' do
        #Act
        visit edit_car_model_path(3301)

        #Assert
        expect(current_path).to eq new_user_session_path
    end

    scenario '(must be authenticated to edit it)' do
        #Act
        page.driver.submit :patch, car_model_path(3301), {}

        #Assert
        expect(current_path).to eq new_user_session_path
    end
end