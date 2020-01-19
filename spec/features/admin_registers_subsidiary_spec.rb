require 'rails_helper'

feature 'Admin registers subsidiary' do
    scenario 'successfully' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Filiais'

        click_on 'Registrar nova filial'

        fill_in 'Nome', with: 'FilialTeste'
        fill_in 'CNPJ', with: '01234567891011'
        fill_in 'Endereço', with: 'Rua Teste'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('FilialTeste')
        expect(page).to have_content('01234567891011')
        expect(page).to have_content('Rua Teste')
        expect(page).to have_content('Filial criada com sucesso')
    end

    scenario '(cnpj must be unique)' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        filial = Subsidiary.create!(name: 'FilialTeste1', cnpj: '01234567891011', address: 'Rua Teste1')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Filiais'

        click_on 'Registrar nova filial'

        fill_in 'Nome', with: 'FilialTeste1'
        fill_in 'CNPJ', with: '01234567891011'
        fill_in 'Endereço', with: 'Rua Teste1'
        click_on 'Enviar'

        #Assert
        expect(page).to have_field('Nome', with: 'FilialTeste1')
        expect(page).to have_field('CNPJ', with: '01234567891011')
        expect(page).to have_field('Endereço', with: 'Rua Teste1')
        
        expect(page).to have_content('Filial deve ser única')
    end

    scenario '(cnpj must be valid)' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Filiais'

        click_on 'Registrar nova filial'

        fill_in 'Nome', with: 'FilialTeste1'
        fill_in 'CNPJ', with: '0123a'
        fill_in 'Endereço', with: 'Rua Teste1'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('CNPJ deve ser válido')
    end

    scenario '(must be authenticated to access the create form)' do
        #Act
        visit new_subsidiary_path

        #Assert
        expect(current_path).to eq new_user_session_path
    end

    scenario '(must be authenticated to register it)' do
        #Act
        page.driver.submit :post, subsidiaries_path, {}

        #Assert
        expect(current_path).to eq new_user_session_path
    end
end