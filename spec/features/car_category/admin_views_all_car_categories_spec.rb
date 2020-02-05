require 'rails_helper'

feature 'Admin views all car categories' do
    scenario 'successfully' do
        #Arrange
        user = create(:user)
        create(:car_category, name: 'catA')
        create(:car_category, name: 'catB')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Categorias de carro'

        #Assert
        expect(page).to have_content('catA')
        expect(page).to have_content('catB')
    end

    scenario 'and returns to home page' do
        #Arrange
        user = create(:user)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Categorias de carro'
        click_on 'Voltar'
    
        #Assert
        expect(current_path).to eq root_path
    end

    scenario '(must be authenticated to have access from the menu)' do
        #Act
        visit root_path

        #Assert
        expect(page).to_not have_link('Categorias de carro')
    end

    scenario '(must be authenticated to have access from the url)' do
        #Act
        visit car_categories_path

        #Assert
        expect(current_path).to eq new_user_session_path
    end
end