require 'rails_helper'

feature 'User register client' do
    scenario 'successfully' do
        #Act
        visit root_path
        click_on 'Clientes'

        click_on 'Registrar novo cliente'

        fill_in 'Nome', with: 'ClienteTeste1'
        fill_in 'CPF', with: '42074026838'
        fill_in 'Email', with: 'ale@gmail.com'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Cliente registrado com sucesso')
        expect(page).to have_content('ClienteTeste1')
        expect(page).to have_content('42074026838')
        expect(page).to have_content('ale@gmail.com')
    end

    scenario 'all fields must be filled' do
        #Act
        visit root_path
        click_on 'Clientes'

        click_on 'Registrar novo cliente'

        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Nome deve ser preenchido')
        expect(page).to have_content('CPF deve ser preenchido')
        expect(page).to have_content('Email deve ser preenchido')
    end

    scenario 'CPF and Email must be unique' do
        #Arrange
        Client.create!(name: 'ClienteTeste1', cpf: '42074026838', email: 'ale@gmail.com')
        
        #Act
        visit root_path
        click_on 'Clientes'

        click_on 'Registrar novo cliente'

        fill_in 'Nome', with: 'ClienteTeste1'
        fill_in 'CPF', with: '42074026838'
        fill_in 'Email', with: 'ale@gmail.com'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('CPF deve ser único')
        expect(page).to have_content('Email deve ser único')
    end

    scenario 'CPF and Email must be valid' do
        #Act
        visit root_path
        click_on 'Clientes'

        click_on 'Registrar novo cliente'

        fill_in 'Nome', with: 'ClienteTeste1'
        fill_in 'CPF', with: '42074026'
        fill_in 'Email', with: 'ale@gmailcom'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('CPF deve ser válido')
        expect(page).to have_content('Email deve ser válido')
    end
end