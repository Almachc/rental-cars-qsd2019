require 'rails_helper'

feature 'User views client details' do
    scenario 'successfully' do
        #Arrange
        user = create(:user)
        create(:client)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Clientes'

        click_on 'Leopoldo'

        #Assert
        expect(page).to have_content('Leopoldo')
        expect(page).to have_content('42074026838')
        expect(page).to have_content('leopoldo@gmail.com')
        expect(page).to have_link('Voltar')
    end

    scenario 'and back clients home page' do
        #Arrange
        user = create(:user)
        create(:client)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Clientes'

        click_on 'Leopoldo'

        click_on 'Voltar'

        #Assert
        expect(current_path).to eq clients_path
    end

    scenario '(must be authenticate to have access from the url)' do
        #Act
        visit client_path(3301)

        #Arrange
        expect(current_path).to eq new_user_session_path
    end
end