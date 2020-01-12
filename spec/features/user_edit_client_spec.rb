require 'rails_helper'

feature 'User edit client' do
    scenario 'succesfully' do
        #Arrange
        Client.create!(name: 'ClienteTestk', cpf: '42074026838', email: 'teste1@gmail.com')

        #Act
        visit root_path
        click_on 'Clientes'
        
        click_on 'ClienteTestk'

        click_on 'Editar'

        fill_in 'Nome', with: 'ClienteTeste'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Cliente editado com sucesso')
        expect(page).to have_content('ClienteTeste')
        expect(page).not_to have_content('ClienteTestk')
    end

    scenario 'all fields must be filled' do
        #Arrange
        Client.create!(name: 'ClienteTeste1', cpf: '42074026838', email: 'cliente1@gmail.com')
    
        #Act
        visit root_path
        click_on 'Clientes'

        click_on 'ClienteTeste1'

        click_on 'Editar'

        fill_in 'Nome', with: ''
        fill_in 'CPF', with: ''
        fill_in 'Email', with: ''

        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Nome deve ser preenchido')
        expect(page).to have_content('CPF deve ser preenchido')
        expect(page).to have_content('Email deve ser preenchido')
    end

    scenario 'CPF and Email must be unique' do
        #Arrange
        Client.create!(name: 'ClienteTeste1', cpf: '42074026888', email: 'cliente1@gmail.com')
        Client.create!(name: 'ClienteTeste2', cpf: '42074026999', email: 'cliente2@gmail.com')

        #Act
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

    scenario 'CPF and Email must be valid' do
        #Arrange
        Client.create!(name: 'ClienteTeste1', cpf: '42074026888', email: 'cliente1@gmail.com')

        #Act
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
end