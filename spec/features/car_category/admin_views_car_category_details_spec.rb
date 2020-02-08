require 'rails_helper'

feature 'Admin views car category details' do
    scenario 'successfully' do
        #Arrange
        user = create(:user)
        car_category = create(:car_category)
        
        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Categorias de carro'
        click_on 'catA'
    
        #Assert
        expect(page).to have_content(car_category.name)
        expect(page).to have_content(car_category.daily_rate)
        expect(page).to have_content(car_category.car_insurance)
        expect(page).to have_content(car_category.third_party_insurance)
    end

    scenario 'and returns to car categories home page' do
        #Arrange
        user = create(:user)
        create(:car_category)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Categorias de carro'

        click_on 'catA'

        click_on 'Voltar'

        #Assert
        expect(current_path).to eq car_categories_path
    end

    scenario '(must be authenticated to have access from the url)' do
        #Act
        visit car_category_path(3301)

        #Assert
        expect(current_path).to eq new_user_session_path
    end
end