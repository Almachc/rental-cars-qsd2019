require 'rails_helper'

feature 'User view clients' do
    scenario 'successfully' do
        #Arrange
        Client.create!(name: 'ClienteTeste1', cpf: '42074026838', email: 'teste1@gmail.com')
        Client.create!(name: 'ClienteTeste2', cpf: '42074026839', email: 'teste2@gmail.com')

        #Act
        visit root_path
        click_on 'Clientes'

        click_on 'ClienteTeste1'

        #Assert
        expect(page).to have_content('ClienteTeste1')
        expect(page).to have_content('42074026838')
        expect(page).to have_content('teste1@gmail.com')
        expect(page).to have_link('Voltar')
    end

    scenario 'and back home page' do
        #Arrange
        Client.create!(name: 'ClienteTeste1', cpf: '42074026838', email: 'teste1@gmail.com')
        Client.create!(name: 'ClienteTeste2', cpf: '42074026839', email: 'teste2@gmail.com')

        #Act
        visit root_path
        click_on 'Clientes'

        click_on 'ClienteTeste2'

        click_on 'Voltar'

        #Assert
        expect(current_path).to have_content(root_path)
    end
end