require 'rails_helper'

feature 'Admin view car models details' do
    scenario 'successfully' do
        #Arrange
        user = create(:user)
        car_model = create(:car_model)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Modelos de carro'

        click_on 'HB20'

        #Assert
        expect(page).to have_content(car_model.name)
        expect(page).to have_content(car_model.year)
        expect(page).to have_content(car_model.motorization)
        expect(page).to have_content(car_model.fuel_type)
        expect(page).to have_content(car_model.manufacturer.name)
        expect(page).to have_content(car_model.car_category.name)
    end

    scenario 'and returns to car models home page' do
        #Arrange
        user = create(:user)
        car_model = create(:car_model)
    
        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Modelos de carro'

        click_on 'HB20'

        click_on 'Voltar'
    
        #Assert
        expect(current_path).to eq car_models_path
    end

    scenario '(must be authenticated to have access from the url)' do
        #Act
        visit car_model_path(3301)

        #Assert
        expect(current_path).to eq new_user_session_path
    end
end