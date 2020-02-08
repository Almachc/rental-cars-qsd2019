require 'rails_helper'

feature 'Admin views subsidiary details' do
    scenario 'successfully' do
        #Arrange
        user = create(:user)
        filial = create(:subsidiary)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Filiais'
        click_on 'Filial1'

        #Assert
        expect(page).to have_content(filial.name)
        expect(page).to have_content(filial.cnpj)
        expect(page).to have_content(filial.address)
    end

    scenario 'and returns to the subsidiarys home page' do
        #Arrange
        user = create(:user)
        filial = create(:subsidiary)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Filiais'
        click_on 'Filial1'
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