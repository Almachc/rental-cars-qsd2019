require 'rails_helper'

feature 'Admin views subsidiary details' do
    scenario 'successfully' do
        #Arrange
        Subsidiary.create!(name: 'FilialTeste1', cnpj:'01234567891011', address: 'Rua Teste1')

        #Act
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
        Subsidiary.create!(name: 'FilialTeste1', cnpj:'01234567891011', address: 'Rua Teste1')

        #Act
        visit root_path
        click_on 'Filiais'
        click_on 'FilialTeste1'
        click_on 'Voltar'

        #Assert
        expect(current_path).to eq subsidiaries_path
    end
end