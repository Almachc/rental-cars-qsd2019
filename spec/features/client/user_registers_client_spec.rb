require 'rails_helper'

feature 'User registers client' do
    scenario 'successfully' do
        #Arrange
        user = create(:user)
       
        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Clientes'

        click_on 'Registrar novo cliente'

        fill_in 'Nome', with: 'Cliente1'
        fill_in 'CPF', with: '42074026838'
        fill_in 'Email', with: 'cliente1@gmail.com'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Cliente1')
        expect(page).to have_content('42074026838')
        expect(page).to have_content('cliente1@gmail.com')

        expect(page).to have_content('Cliente registrado com sucesso')
    end

    scenario '(all fields must be filled)' do
        #Arrange
        user = create(:user)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Clientes'

        click_on 'Registrar novo cliente'

        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Nome deve ser preenchido')
        expect(page).to have_content('CPF deve ser preenchido')
        expect(page).to have_content('Email deve ser preenchido')
    end

    scenario '(CPF and Email must be unique)' do
        #Arrange
        user = create(:user)
        create(:client, name: 'Cliente1', cpf: '42074026838', email: 'cliente1@gmail.com')
        
        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Clientes'

        click_on 'Registrar novo cliente'

        fill_in 'Nome', with: 'Cliente2'
        fill_in 'CPF', with: '42074026838'
        fill_in 'Email', with: 'cliente1@gmail.com'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('CPF deve ser único')
        expect(page).to have_content('Email deve ser único')
    end

    scenario '(CPF and Email must be valid)' do
        #Arrange
        user = create(:user)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Clientes'

        click_on 'Registrar novo cliente'

        fill_in 'Nome', with: 'Cliente1'
        fill_in 'CPF', with: '42074026'
        fill_in 'Email', with: 'ale@gmailcom'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('CPF deve ser válido')
        expect(page).to have_content('Email deve ser válido')
    end

    scenario '(must be authenticated to access the create form)' do
        #Act
        visit new_client_path

        #Assert
        expect(current_path).to eq new_user_session_path
    end

    scenario '(must be authenticated to register it)' do
        #Act
        page.driver.submit :post, clients_path, {}

        #Assert
        expect(current_path).to eq new_user_session_path
    end
end