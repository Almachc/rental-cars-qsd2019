require 'rails_helper'

feature 'User delete client' do
    scenario 'successfully' do
        #Arrange
        Client.create!(name: 'ClienteTeste1', cpf: '42074026838', email: 'teste1@gmail.com')
        Client.create!(name: 'ClienteTeste2', cpf: '42074026839', email: 'teste2@gmail.com')

        #Act
        visit root_path
        click_on 'Clientes'

        click_on 'ClienteTeste1'
        click_on 'Deletar'

        #Assert
        expect(page).to have_content('Cliente deletado com sucesso')
        expect(page).to have_content('ClienteTeste2')
        expect(page).not_to have_content('ClienteTeste1')
    end
end