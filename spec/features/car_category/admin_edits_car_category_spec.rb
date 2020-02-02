require 'rails_helper'

feature 'Admin edits car category' do
    scenario 'successfully' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Categorias de carro'
        click_on 'T1'
        click_on 'Editar'

        fill_in 'Nome', with: 'T2'
        fill_in 'Seguro do carro', with: '2.5'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('T2')
        expect(page).to have_content('1.2')
        expect(page).to have_content('2.5')
        expect(page).to have_content('1.4')

        expect(page).to have_content('Categoria editada com sucesso')
    end

    scenario '(all fields must be filled)' do
       #Arrange
       user = User.create!(email: 'teste@teste.com', password: '123456')
       CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)

       #Act
       login_as(user, scope: :user)
       visit root_path
       click_on 'Categorias de carro'
       click_on 'T1'
       click_on 'Editar'

       fill_in 'Nome', with: ''
       fill_in 'Diária', with: ''
       fill_in 'Seguro do carro', with: ''
       fill_in 'Seguro contra terceiros', with: ''
       click_on 'Enviar'

        #Assert
        expect(page).to have_content('Nome deve ser preenchido')
        expect(page).to have_content('Diária deve ser preenchido')
        expect(page).to have_content('Seguro do carro deve ser preenchido')
        expect(page).to have_content('Seguro contra terceiros deve ser preenchido')
    end

    scenario '(daily rate, car insurance and third party insurance must be greater than zero)' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Categorias de carro'

        click_on 'T1'

        click_on 'Editar'

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

    scenario '(must be authenticated to have access to the edit form)' do
        #Act
        visit edit_car_category_path(3301)

        #Assert
        expect(current_path).to eq new_user_session_path
    end

    scenario '(must be authenticated to edit it)' do
        #Act
        page.driver.submit :patch, car_category_path(3301), {}

        #Assert
        expect(current_path).to eq new_user_session_path
    end
end