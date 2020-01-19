require 'rails_helper'

feature 'User views client details' do
    scenario 'successfully' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        Client.create!(name: 'ClienteTeste1', cpf: '42074026838', email: 'teste1@gmail.com')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Clientes'

        click_on 'ClienteTeste1'

        #Assert
        expect(page).to have_content('ClienteTeste1')
        expect(page).to have_content('42074026838')
        expect(page).to have_content('teste1@gmail.com')
        expect(page).to have_link('Voltar')
    end

    scenario 'and back clients home page' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        Client.create!(name: 'ClienteTeste1', cpf: '42074026838', email: 'teste1@gmail.com')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Clientes'

        click_on 'ClienteTeste1'

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