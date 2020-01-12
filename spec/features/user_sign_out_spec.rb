require 'rails_helper'

feature 'User sign_out' do
    scenario 'successfully' do
        #Arrange
        User.create!(email: 'user1@gmail.com', password: '123456')

        #Act
        visit root_path
        click_on 'Entrar'

        fill_in 'Email', with: 'user1@gmail.com'
        fill_in 'Password', with: '123456'
        click_on 'Log in'
        
        click_on 'Clientes'

        click_on 'Sair'

        #Assert
        expect(page).to have_content('Signed out successfully')
        expect(page).to have_link('Entrar')
        expect(page).not_to have_link('Sair')
        expect(current_path).to have_content(root_path)
    end
end