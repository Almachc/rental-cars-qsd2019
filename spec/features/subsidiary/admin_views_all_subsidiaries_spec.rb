require 'rails_helper'

feature 'Admin views all subsidiaries' do
    scenario 'successfully' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        Subsidiary.create!(name: 'FilialTeste1', cnpj:'01234567891011', address: 'Rua Teste1')
        Subsidiary.create!(name: 'FilialTeste2', cnpj:'01234567891012', address: 'Rua Teste2')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Filiais'
        
        #Assert
        expect(page).to have_content('FilialTeste1')
        expect(page).to have_content('FilialTeste2')
      
        expect(page).to have_link('Voltar')
    end

    scenario 'and returns to home page' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Filiais'

        click_on 'Voltar'
    
        #Assert
        expect(current_path).to eq root_path
    end

    scenario '(must be authenticated to have access from the menu)' do
        #Act
        visit root_path

        #Assert
        expect(page).to_not have_link('Filiais')
    end

    scenario '(must be authenticated to have access from the url)' do
        #Act
        visit subsidiaries_path

        #Assert
        expect(current_path).to eq new_user_session_path
    end
end