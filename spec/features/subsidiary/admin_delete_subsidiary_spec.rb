require 'rails_helper'

feature 'Admin delete subsidiary' do
    scenario 'successfully' do
        #Arrange
        user = create(:user)
        create(:subsidiary, name: 'Filial1', cnpj: '01234567891011')
        create(:subsidiary, name: 'Filial2', cnpj: '55234567891022')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Filiais'

        click_on 'Filial1'
        click_on 'Deletar'

        #Assert
        expect(Subsidiary.count).to eq 1

        expect(current_path).to eq subsidiaries_path

        expect(page).to have_content('Filial deletada com sucesso')
        expect(page).to have_content('Filial2')
        expect(page).to have_no_content('Filial1')
    end

    scenario '(must be authenticated)' do
        #Act
        page.driver.submit :delete, subsidiary_path(3301), {}

        #Assert
        expect(current_path).to eq new_user_session_path
    end
end