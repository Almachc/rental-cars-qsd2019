require 'rails_helper'

feature 'User delete client' do
    scenario 'successfully' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        Client.create!(name: 'ClienteTeste1', cpf: '42074026838', email: 'teste1@gmail.com')
        Client.create!(name: 'ClienteTeste2', cpf: '42074026839', email: 'teste2@gmail.com')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Clientes'

        click_on 'ClienteTeste1'
        click_on 'Deletar'

        #Assert
        expect(page).to have_content('Cliente deletado com sucesso')
        expect(page).to have_content('ClienteTeste2')
        expect(page).not_to have_content('ClienteTeste1')
    end

    scenario '(must be authenticated)' do
        #Arrange
        cliente = Client.create!(name: 'ClienteTeste1', cpf: '42074026838', email: 'teste1@gmail.com')

        #Act
        page.driver.submit :delete, subsidiary_path(3301), {}
        cliente = Client.find(cliente.id)

        #Assert
        expect(current_path).to eq new_user_session_path
        expect(cliente && true).to eq true
    end
end