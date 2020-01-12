require 'rails_helper'

feature 'User register client' do
    scenario 'successfully' do
        #Act
        visit root_path
        click_on 'Clientes'

        click_on 'Registrar novo cliente'

        fill_in 'Nome', with: 'ClienteTeste1'
        fill_in 'CPF', with: '42074026838'
        fill_in 'Email', with: 'ale@gmail.com'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Cliente registrado com sucesso')
        expect(page).to have_content('ClienteTeste1')
        expect(page).to have_content('42074026838')
        expect(page).to have_content('ale@gmail.com')
    end
end