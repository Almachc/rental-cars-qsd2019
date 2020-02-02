require 'rails_helper'

feature 'Admin views subsidiary details' do
    scenario 'successfully' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        Subsidiary.create!(name: 'FilialTeste1', cnpj:'01234567891011', address: 'Rua Teste1')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Filiais'
        click_on 'FilialTeste1'

        #Assert
        expect(page).to have_content('FilialTeste1')
        expect(page).to have_content('01234567891011')
        expect(page).to have_content('Rua Teste1')
    end

    scenario 'and returns to the subsidiarys home page' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        Subsidiary.create!(name: 'FilialTeste1', cnpj:'01234567891011', address: 'Rua Teste1')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Filiais'
        click_on 'FilialTeste1'
        click_on 'Voltar'

        #Assert
        expect(current_path).to eq subsidiaries_path
    end

    scenario '(must be authenticated to have access from the url)' do
        #Act
        visit subsidiary_path(3301)

        #Assert
        expect(current_path).to eq new_user_session_path
    end
end