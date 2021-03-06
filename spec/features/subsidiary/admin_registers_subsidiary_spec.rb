require 'rails_helper'

feature 'Admin registers subsidiary' do
    scenario 'successfully' do
        #Arrange
        user = create(:user)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Filiais'

        click_on 'Registrar nova filial'

        fill_in 'Nome', with: 'FilialTeste'
        fill_in 'CNPJ', with: '01234567891011'
        fill_in 'Endereço', with: 'Rua Seila'
        click_on 'Enviar'

        #Assert
        expect(Subsidiary.count).to eq 1
        subsidiary = Subsidiary.first
        expect(subsidiary).to have_attributes(name: 'FilialTeste', cnpj: '01234567891011',
                                              address: 'Rua Seila')

        expect(current_path).to eq subsidiary_path(subsidiary)

        expect(page).to have_content('Filial registrada com sucesso')
        expect(page).to have_content('FilialTeste')
        expect(page).to have_content('01234567891011')
        expect(page).to have_content('Rua Seila')
    end

    scenario '(cnpj must be unique)' do
        #Arrange
        user = create(:user)
        create(:subsidiary, cnpj: '01234567891011')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Filiais'

        click_on 'Registrar nova filial'

        fill_in 'Nome', with: 'FilialTeste1'
        fill_in 'CNPJ', with: '01234567891011'
        fill_in 'Endereço', with: 'Rua Seila'
        click_on 'Enviar'

        #Assert
        expect(page).to have_field('Nome', with: 'FilialTeste1')
        expect(page).to have_field('CNPJ', with: '01234567891011')
        expect(page).to have_field('Endereço', with: 'Rua Seila')
        
        expect(page).to have_content('CNPJ já está em uso')
    end

    scenario '(cnpj must be valid)' do
        #Arrange
        user = create(:user)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Filiais'

        click_on 'Registrar nova filial'

        fill_in 'Nome', with: 'FilialTeste1'
        fill_in 'CNPJ', with: '0123a'
        fill_in 'Endereço', with: 'Rua Seila'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('CNPJ não é válido')
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