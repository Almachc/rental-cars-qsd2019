require 'rails_helper'

feature 'User views client details' do
    scenario 'successfully' do
        #Arrange
        user = create(:user)
        client = create(:client)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Clientes'

        click_on 'Leopoldo'

        #Assert
        expect(current_path).to eq client_path(client)

        expect(page).to have_content(client.name)
        expect(page).to have_content(client.cpf)
        expect(page).to have_content(client.email)
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