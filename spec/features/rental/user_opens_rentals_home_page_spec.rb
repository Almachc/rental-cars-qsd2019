require 'rails_helper'

feature 'User opens rentals home page' do
    scenario 'successfully' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Locações'

        #Assert
        expect(current_path).to eq(rentals_path)
    end

    scenario 'and back home page' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        
        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Locações'

        click_on 'Voltar'

        #Assert
        expect(current_path).to eq root_path
    end

    scenario '(must be authenticated to have access from the menu)' do
        #Act
        visit root_path

        #Assert
        expect(page).to_not have_link('Locações')
    end

    scenario '(must be authenticated to have access from the url)' do
        #Act
        visit rentals_path

        #Assert
        expect(current_path).to eq new_user_session_path
    end
end