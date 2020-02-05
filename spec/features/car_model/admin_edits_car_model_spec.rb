require 'rails_helper'

feature 'Admin edits car model' do
    scenario 'successfully' do
        #Arrange
        user = create(:user)
        create(:car_model)
        
        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Modelos de carro'
        click_on 'HB20'
        click_on 'Editar'
        
        fill_in 'Ano', with: '2015'

        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Modelo editado com sucesso')
        expect(page).not_to have_content('2019')
        expect(page).to have_content('2015')
    end

    scenario '(all fields must be filled)' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
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
        expect(page).to have_field('Nome', with: '')
        expect(page).to have_field('Ano', with: '')
        expect(page).to have_field('Fabricante', with: '1')
        expect(page).to have_field('Motorização', with: '')
        expect(page).to have_field('Categoria de carro', with: '1')
        expect(page).to have_field('Tipo de combustível', with: '')

        expect(page).to have_content('Nome deve ser preenchido')
        expect(page).to have_content('Ano deve ser preenchido')
        #expect(page).to have_content('Fabricante deve ser preenchido')
        expect(page).to have_content('Motorização deve ser preenchido')
        #expect(page).to have_content('Categoria de carro deve ser preenchido')
        expect(page).to have_content('Tipo de combustível deve ser preenchido')
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