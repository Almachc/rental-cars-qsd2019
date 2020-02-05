require 'rails_helper'

feature 'Admin views all car models' do
    scenario 'successfully' do
        #Arrange
        user = create(:user)
        manufacturer = create(:manufacturer)
        car_category = create(:car_category)

        create(:car_model, name: 'HB20', manufacturer: manufacturer, car_category: car_category)
        create(:car_model, name: 'Azera', manufacturer: manufacturer, car_category: car_category)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Modelos de carro'

        #Assert
        expect(page).to have_content('HB20')
        expect(page).to have_content('Azera')
    end

    scenario 'and returns to home page' do
        #Arrange
        user = create(:user)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Modelos de carro'
       
        click_on 'Voltar'
    
        #Assert
        expect(current_path).to eq root_path
    end

    scenario '(must be authenticated to have access from the menu)' do
        #Act
        visit root_path

        #Assert
        expect(page).to_not have_link('Modelos de carro')
    end

    scenario '(must be authenticated to have access from the url)' do
        #Act
        visit car_models_path

        #Assert
        expect(current_path).to eq new_user_session_path
    end
end