require 'rails_helper'

feature 'User edits client' do
    scenario 'succesfully' do
        #Arrange
        user = create(:user)
        client = create(:client, name: 'Leopolafsd')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Clientes'
        click_on 'Leopolafsd'
        click_on 'Editar'

        fill_in 'Nome', with: 'Leopoldo'
        click_on 'Enviar'

        #Assert
        expect(client.reload.name).to eq('Leopoldo')

        expect(current_path).to eq client_path(client)

        expect(page).to have_content('Cliente editado com sucesso')
        expect(page).to have_content('Leopoldo')
        expect(page).not_to have_content('Leopolafsd')
        expect(page).to have_content(client.cpf)
        expect(page).to have_content(client.email)
    end

    scenario '(all fields must be filled)' do
        #Arrange
        user = create(:user)
        create(:client)
    
        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Clientes'
        click_on 'Leopoldo'
        click_on 'Editar'

        fill_in 'Nome', with: ''
        fill_in 'CPF', with: ''
        fill_in 'Email', with: ''
        click_on 'Enviar'

        #Assert
        expect(Client.first).to_not have_attributes(name: '', cpf: '', email: '')

        expect(page).to have_field('Nome', with: '')
        expect(page).to have_field('CPF', with: '')
        expect(page).to have_field('Email', with: '')

        expect(page).to have_content('Nome deve ser preenchido')
        expect(page).to have_content('CPF deve ser preenchido')
        expect(page).to have_content('Email deve ser preenchido')
    end

    scenario '(CPF and Email must be unique)' do
        #Arrange
        user = create(:user)
        client = create(:client, name: 'Leopoldo', cpf: '42074026838', email: 'leopoldo@gmail.com')
        create(:client, name: 'Barney', cpf: '72074026856', email: 'barney@gmail.com')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Clientes'

        click_on 'Leopoldo'

        click_on 'Editar'

        fill_in 'CPF', with: '72074026856'
        fill_in 'Email', with: 'barney@gmail.com'
        click_on 'Enviar'

        #Assert
        expect(client.reload).to have_attributes(cpf: '42074026838', email: 'leopoldo@gmail.com') 

        expect(page).to have_content('CPF deve ser único')
        expect(page).to have_content('Email deve ser único')
    end

    scenario '(CPF and Email must be valid)' do
        #Arrange
        user = create(:user)
        client = create(:client)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Clientes'
        click_on 'Leopoldo'
        click_on 'Editar'

        fill_in 'CPF', with: '42074026'
        fill_in 'Email', with: 'leopoldo@gmailcom'
        click_on 'Enviar'

        #Assert
        expect(client.reload).to_not have_attributes(cpf: '42074026', email: 'leopoldo@gmailcom') 

        expect(page).to have_content('CPF deve ser válido')
        expect(page).to have_content('Email deve ser válido')
    end

    scenario '(must be authenticated to have access to the edit form)' do
        #Act
        visit edit_client_path('whatever')

        #Assert
        expect(current_path).to eq new_user_session_path
    end

    scenario '(must be authenticated to edit it)' do
        #Act
        page.driver.submit :patch, client_path('whatever'), {}

        #Assert
        expect(current_path).to eq new_user_session_path
    end
end