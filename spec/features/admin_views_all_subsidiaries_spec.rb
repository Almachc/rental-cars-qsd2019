require 'rails_helper'

feature 'Admin views all subsidiaries' do
    scenario 'successfully' do
        #Arrange
        Subsidiary.create!(name: 'FilialTeste1', cnpj:'01234567891011', address: 'Rua Teste1')
        Subsidiary.create!(name: 'FilialTeste2', cnpj:'01234567891012', address: 'Rua Teste2')

        #Act
        visit root_path
        click_on 'Filiais'
        
        #Assert
        expect(page).to have_content('FilialTeste1')
        expect(page).to have_content('FilialTeste2')
      
        expect(page).to have_link('Voltar')
    end

    scenario 'and returns to home page' do
        visit root_path
        click_on 'Filiais'
        click_on 'Voltar'
    
        expect(current_path).to eq root_path
      end
end