require 'rails_helper'

feature 'User views all clients' do
    scenario 'successfully' do
        #Arrange
        user = create(:user)
        create(:client, name: 'Leopoldo', cpf: '42074026838', email: 'leopoldo@gmail.com')
        create(:client, name: 'Barney', cpf: '72074026856', email: 'barney@gmail.com')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Clientes'

        #Assert
        expect(page).to have_content('Leopoldo')
        expect(page).to have_content('Barney')
    end

    scenario 'and back home page' do
        #Arrange
        user = create(:user)
        
        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Clientes'

        click_on 'Voltar'

        #Assert
        expect(current_path).to eq root_path
    end

    scenario '(must be authenticate to have access from the menu)' do
        #Act
        visit root_path

        #Arrange
        expect(page).to_not have_link('Clientes')
    end

    scenario '(must be authenticate to have access from the url)' do
        #Act
        visit clients_path

        #Arrange
        expect(current_path).to eq new_user_session_path
    end
end