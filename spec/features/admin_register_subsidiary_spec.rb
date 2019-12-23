require 'rails_helper'

feature 'Admin register subsidiary' do
    scenario 'successfully' do
        #Act
        visit root_path
        click_on 'Filiais'

        click_on 'Registrar nova filial'

        fill_in 'Nome', with: 'FilialTeste'
        fill_in 'CNPJ', with: '01234567891011'
        fill_in 'Endereço', with: 'Rua Teste'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('FilialTeste')
        expect(page).to have_content('Filial criada com sucesso')
    end

    scenario 'cnpj must be unique' do
        #Arrange
        Subsidiary.create!(name: 'FilialTeste1', cnpj: '01234567891011', address: 'Rua Teste1')

        #Act
        visit root_path
        click_on 'Filiais'

        click_on 'Registrar nova filial'

        fill_in 'Nome', with: 'FilialTeste1'
        fill_in 'CNPJ', with: '01234567891011'
        fill_in 'Endereço', with: 'Rua Teste1'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Filial já existente')
    end

    scenario 'cnpj must be valid' do
        #Act
        visit root_path
        click_on 'Filiais'

        click_on 'Registrar nova filial'

        fill_in 'Nome', with: 'FilialTeste1'
        fill_in 'CNPJ', with: '0123a'
        fill_in 'Endereço', with: 'Rua Teste1'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('CNPJ inválido')
    end
end