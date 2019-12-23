require 'rails_helper'

feature 'Admin edit subsidiary' do
    scenario 'successfully' do
        #Arrange
        Subsidiary.create!(name: 'FilialTeste1', cnpj: '01234567891011', address: 'Rua Test')

        #Act
        visit root_path
        click_on 'Filiais'

        click_on 'FilialTeste1'

        click_on 'Editar'

        fill_in 'Endereço', with: 'Rua Teste1'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Filial editada com sucesso')
        expect(page).to have_content('Rua Teste1')
    end

    scenario 'cnpj must be unique' do
        #Arrange
        Subsidiary.create!(name: 'FilialTeste1', cnpj: '01234567891011', address: 'Rua Teste1')
        Subsidiary.create!(name: 'FilialTeste2', cnpj: '01234567891012', address: 'Rua Teste2')

        #Act
        visit root_path
        click_on 'Filiais'

        click_on 'FilialTeste2'

        click_on 'Editar'

        fill_in 'CNPJ', with: '01234567891011'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Filial já existente')
    end

    scenario 'cnpj must be valid' do
        #Arrange
        Subsidiary.create!(name: 'FilialTeste1', cnpj: '01234567891011', address: 'Rua Teste1')

        #Act
        visit root_path
        click_on 'Filiais'

        click_on 'FilialTeste1'

        click_on 'Editar'

        fill_in 'CNPJ', with: '0123456789101a'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('CNPJ inválido')
    end
end