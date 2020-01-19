require 'rails_helper'

feature 'Admin registers car category' do
    scenario 'successfully' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        
        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Categorias de carro'

        click_on 'Registrar nova categoria de carro'

        fill_in 'Nome', with: 'T1'
        fill_in 'Diária', with: '1.2'
        fill_in 'Seguro do carro', with: '1.3'
        fill_in 'Seguro contra terceiros', with: '1.4'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('T1')
        expect(page).to have_content('1.2')
        expect(page).to have_content('1.3')
        expect(page).to have_content('1.4')
        expect(page).to have_content('Categoria criada com sucesso')
    end

    scenario '(all fields must be filled)' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Categorias de carro'

        click_on 'Registrar nova categoria de carro'

        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Nome deve ser preenchido')
        expect(page).to have_content('Diária deve ser preenchido')
        expect(page).to have_content('Seguro do carro deve ser preenchido')
        expect(page).to have_content('Seguro contra terceiros deve ser preenchido')
    end

    scenario '(daily Rate, car insurance and third party insurance must be greater than zero)' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        
        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Categorias de carro'

        click_on 'Registrar nova categoria de carro'

        fill_in 'Nome', with: 'T1'
        fill_in 'Diária', with: '0'
        fill_in 'Seguro do carro', with: '0'
        fill_in 'Seguro contra terceiros', with: '0'
        click_on 'Enviar'

        #Assert
        expect(page).to have_field('Nome', with: 'T1')
        expect(page).to have_field('Diária', with: '0')
        expect(page).to have_field('Seguro do carro', with: '0')
        expect(page).to have_field('Seguro contra terceiros', with: '0')

        expect(page).to have_content('Diária deve ser maior que zero')
        expect(page).to have_content('Seguro do carro deve ser maior que zero')
        expect(page).to have_content('Seguro contra terceiros deve ser maior que zero')
    end

    scenario '(must be authenticated to have access to the create form)' do
        #Act
        visit new_car_category_path

        #Assert
        expect(current_path).to eq new_user_session_path
    end

    scenario '(must be authenticated to create it)' do
        #Act
        page.driver.submit :post, car_categories_path, {}
        
        #Assert
        expect(current_path).to eq new_user_session_path
    end
end