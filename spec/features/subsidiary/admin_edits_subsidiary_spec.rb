require 'rails_helper'

feature 'Admin edits subsidiary' do
    scenario 'successfully' do
        #Arrange
        user = create(:user)
        subsidiary = create(:subsidiary)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Filiais'

        click_on 'Filial1'

        click_on 'Editar'

        fill_in 'Endereço', with: 'Rua Seila Oq'
        click_on 'Enviar'

        #Assert
        expect(Subsidiary.first).to have_attributes(name: subsidiary.name, cnpj: subsidiary.cnpj,
                                                    address: 'Rua Seila Oq')

        expect(current_path).to eq subsidiary_path(subsidiary)

        expect(page).to have_content('Filial editada com sucesso')
        expect(page).to have_content('Rua Seila Oq')
    end

    scenario '(cnpj must be unique)' do
        #Arrange
        user = create(:user)
        create(:subsidiary, name: 'Filial1', cnpj: '01234567891011')
        subsidiary = create(:subsidiary, name: 'Filial2', cnpj: '01234567891012')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Filiais'

        click_on 'Filial2'

        click_on 'Editar'

        fill_in 'CNPJ', with: '01234567891011'
        click_on 'Enviar'

        #Assert
        expect(Subsidiary.find(subsidiary.id)).to have_attributes(name: subsidiary.name, cnpj: subsidiary.cnpj,
                                                    address: subsidiary.address)

        expect(page).to have_content('Filial deve ser única')
        expect(page).to have_field('Nome', with: subsidiary.name)
        expect(page).to have_field('CNPJ', with: '01234567891011')
        expect(page).to have_field('Endereço', with: subsidiary.address)
    end

    scenario '(cnpj must be valid)' do
        #Arrange
        user = create(:user)
        subsidiary = create(:subsidiary)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Filiais'

        click_on 'Filial1'

        click_on 'Editar'

        fill_in 'CNPJ', with: '0123456789101a'
        click_on 'Enviar'

        #Assert
        expect(Subsidiary.first).to have_attributes(name: subsidiary.name, cnpj: subsidiary.cnpj,
                                                    address: subsidiary.address)

        expect(page).to have_content('CNPJ deve ser válido')
    end

    scenario '(must be authenticated to have access to the edit form)' do
        #Act
        visit edit_subsidiary_path('whatever')

        #Assert
        expect(current_path).to eq new_user_session_path
    end

    scenario '(must be authenticated to edit it)' do
        #Act
        page.driver.submit :patch, subsidiary_path('whatever'), {}

        #Assert
        expect(current_path).to eq new_user_session_path
    end
end