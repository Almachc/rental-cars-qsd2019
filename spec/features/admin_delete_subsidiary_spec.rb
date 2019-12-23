require 'rails_helper'

feature 'Admin delete subsidiary' do
    scenario 'successfully' do
        #Arrange
        Subsidiary.create!(name: 'FilialTeste1', cnpj: '01234567891011', address: 'Rua Teste')
        Subsidiary.create!(name: 'FilialTeste2', cnpj: '01234567891012', address: 'Rua Teste2')

        #Act
        visit root_path
        click_on 'Filiais'

        click_on 'FilialTeste1'
        click_on 'Deletar'

        #Assert
        expect(page).to have_content('Filial deletada com sucesso')
        expect(page).to have_content('FilialTeste2')
        expect(page).to have_no_content('FilialTeste1')
    end
end