require 'rails_helper'

feature 'User edits client' do
    scenario 'succesfully' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        cliente = Client.create!(name: 'ClienteTestk', cpf: '42074026838', email: 'teste1@gmail.com')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Clientes'
        
        click_on 'ClienteTestk'

        click_on 'Editar'

        fill_in 'Nome', with: 'ClienteTeste'
        click_on 'Enviar'

        #Assert
        expect(page).not_to have_content('ClienteTestk')
        expect(page).to have_content('ClienteTeste')
        expect(current_path).to eq client_path(cliente)
        expect(page).to have_content('Cliente editado com sucesso')
    end

    scenario '(all fields must be filled)' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        Client.create!(name: 'ClienteTeste1', cpf: '42074026838', email: 'cliente1@gmail.com')
    
        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Clientes'

        click_on 'ClienteTeste1'

        click_on 'Editar'

        fill_in 'Nome', with: ''
        fill_in 'CPF', with: ''
        fill_in 'Email', with: ''

        click_on 'Enviar'

        #Assert
        expect(page).to have_field('Nome', with: '')
        expect(page).to have_field('CPF', with: '')
        expect(page).to have_field('Email', with: '')

        expect(page).to have_content('Nome deve ser preenchido')
        expect(page).to have_content('CPF deve ser preenchido')
        expect(page).to have_content('Email deve ser preenchido')
    end

    scenario '(CPF and Email must be unique)' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        Client.create!(name: 'ClienteTeste1', cpf: '42074026888', email: 'cliente1@gmail.com')
        Client.create!(name: 'ClienteTeste2', cpf: '42074026999', email: 'cliente2@gmail.com')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Clientes'

        click_on 'ClienteTeste1'

        click_on 'Editar'

        fill_in 'CPF', with: '42074026999'
        fill_in 'Email', with: 'cliente2@gmail.com'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('CPF deve ser único')
        expect(page).to have_content('Email deve ser único')
    end

    scenario '(CPF and Email must be valid)' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        Client.create!(name: 'ClienteTeste1', cpf: '42074026888', email: 'cliente1@gmail.com')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Clientes'

        click_on 'ClienteTeste1'

        click_on 'Editar'

        fill_in 'CPF', with: '42074026'
        fill_in 'Email', with: 'ale@gmailcom'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('CPF deve ser válido')
        expect(page).to have_content('Email deve ser válido')
    end

    scenario '(must be authenticated to have access to the edit form)' do
        #Act
        visit edit_client_path(3301)

        #Assert
        expect(current_path).to eq new_user_session_path
    end

    scenario '(must be authenticated to edit it)' do
        #Act
        page.driver.submit :patch, client_path(3301), {}

        #Assert
        expect(current_path).to eq new_user_session_path
    end
end