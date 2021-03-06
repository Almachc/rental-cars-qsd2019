require 'rails_helper'

feature 'User sign_in' do
    scenario 'successfully' do
        #Arrange
        User.create!(email: 'user1@gmail.com', password: '123456')

        #Act
        visit root_path
        click_on 'Entrar'

        within 'form' do
            fill_in 'Email', with: 'user1@gmail.com'
            fill_in 'Senha', with: '123456'
            click_on 'Entrar'
        end

        #Assert
        expect(page).to have_content('Login efetuado com sucesso!')
        expect(page).to have_link('Sair')
        expect(page).not_to have_link('Entrar')
        expect(current_path).to eq(root_path)
    end
end