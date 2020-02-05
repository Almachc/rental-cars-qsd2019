require 'rails_helper'

feature 'User delete client' do
    scenario 'successfully' do
        #Arrange
        user = create(:user)
        create(:client, name: 'Leopoldo', cpf: '42074026838', email: 'leopoldo@gmail.com')
        create(:client, name: 'Barney', cpf: '72074026856', email: 'barney@gmail.com')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Clientes'

        click_on 'Leopoldo'
        click_on 'Deletar'

        #Assert
        expect(page).to have_content('Cliente deletado com sucesso')
        expect(page).to have_content('Barney')
        expect(page).not_to have_content('Leopoldo')
    end

    scenario '(must be authenticated)' do
        #Arrange
        cliente = create(:client)

        #Act
        page.driver.submit :delete, subsidiary_path(3301), {}
        cliente = Client.find(cliente.id)

        #Assert
        expect(current_path).to eq new_user_session_path
        expect(cliente && true).to eq true
    end
end