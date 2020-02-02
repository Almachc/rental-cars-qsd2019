require 'rails_helper'

feature 'Admin views manufacturer details' do
    scenario 'successfully' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        Manufacturer.create!(name: 'Fiat')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Fabricantes'

        click_on 'Fiat'

        #Assert
        expect(page).to have_content('Fiat')
    end

    scenario 'and returns to manufacturers home page' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        Manufacturer.create!(name: 'Fiat')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Fabricantes'

        click_on 'Fiat'

        click_on 'Voltar'
    
        #Assert
        expect(current_path).to eq manufacturers_path
    end

    scenario '(must be authenticated to have access from the url)' do
        #Act
        visit manufacturer_path(3301)

        #Assert
        expect(current_path).to eq new_user_session_path
    end
end