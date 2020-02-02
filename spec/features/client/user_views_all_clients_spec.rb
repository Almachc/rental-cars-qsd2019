require 'rails_helper'

feature 'User views all clients' do
    scenario 'successfully' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        Client.create!(name: 'ClienteTeste1', cpf: '42074026838', email: 'teste1@gmail.com')
        Client.create!(name: 'ClienteTeste2', cpf: '42074026839', email: 'teste2@gmail.com')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Clientes'

        #Assert
        expect(page).to have_content('ClienteTeste1')
        expect(page).to have_content('ClienteTeste2')
    end

    scenario 'and back home page' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        
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