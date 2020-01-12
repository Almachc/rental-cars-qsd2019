require 'rails_helper'

feature 'User edit client' do
    scenario 'succesfully' do
        #Arrange
        Client.create!(name: 'ClienteTestk', cpf: '42074026838', email: 'teste1@gmail.com')

        #Act
        visit root_path
        click_on 'Clientes'
        
        click_on 'ClienteTestk'

        click_on 'Editar'

        fill_in 'Nome', with: 'ClienteTeste'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Cliente editado com sucesso')
        expect(page).to have_content('ClienteTeste')
        expect(page).not_to have_content('ClienteTestk')
    end
end