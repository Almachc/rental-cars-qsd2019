require 'rails_helper'

feature 'Admin views manufacturer details' do
    scenario 'successfully' do
        #Arrange
        user = create(:user)
        manufacturer = create(:manufacturer)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Fabricantes'

        click_on 'Hyundai'

        #Assert
        expect(page).to have_content('Hyundai')
        expect(current_path).to eq manufacturer_path(manufacturer)
    end

    scenario 'and returns to manufacturers home page' do
        #Arrange
        user = create(:user)
        manufacturer = create(:manufacturer)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Fabricantes'

        click_on 'Hyundai'

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