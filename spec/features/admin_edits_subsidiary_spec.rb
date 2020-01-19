require 'rails_helper'

feature 'Admin edits subsidiary' do
    scenario 'successfully' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        filial = Subsidiary.create!(name: 'FilialTeste1', cnpj: '01234567891011', address: 'Rua Test')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Filiais'

        click_on 'FilialTeste1'

        click_on 'Editar'

        fill_in 'Endereço', with: 'Rua Teste1'
        click_on 'Enviar'

        #Assert
        expect(current_path).to eq subsidiary_path(filial)
        expect(page).to have_content('Filial editada com sucesso')
        expect(page).to have_content('Rua Teste1')
    end

    scenario '(cnpj must be unique)' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        Subsidiary.create!(name: 'FilialTeste1', cnpj: '01234567891011', address: 'Rua Teste1')
        Subsidiary.create!(name: 'FilialTeste2', cnpj: '01234567891012', address: 'Rua Teste2')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Filiais'

        click_on 'FilialTeste2'

        click_on 'Editar'

        fill_in 'CNPJ', with: '01234567891011'
        click_on 'Enviar'

        #Assert
        expect(page).to have_field('Nome', with: 'FilialTeste2')
        expect(page).to have_field('CNPJ', with: '01234567891011')
        expect(page).to have_field('Endereço', with: 'Rua Teste2')
        expect(page).to have_content('Filial deve ser única')
    end

    scenario '(cnpj must be valid)' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        Subsidiary.create!(name: 'FilialTeste1', cnpj: '01234567891011', address: 'Rua Teste1')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Filiais'

        click_on 'FilialTeste1'

        click_on 'Editar'

        fill_in 'CNPJ', with: '0123456789101a'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('CNPJ deve ser válido')
    end

    scenario '(must be authenticated to have access to the edit form)' do
        #Act
        visit edit_subsidiary_path(3301)

        #Assert
        expect(current_path).to eq new_user_session_path
    end

    scenario '(must be authenticated to edit it)' do
        #Act
        page.driver.submit :patch, subsidiary_path(3301), {}

        #Assert
        expect(current_path).to eq new_user_session_path
    end
end