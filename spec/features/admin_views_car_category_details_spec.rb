require 'rails_helper'

feature 'Admin views car category details' do
    scenario 'successfully' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
        
        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Categorias de carro'
        click_on 'T1'
    
        #Assert
        expect(page).to have_content('T1')
        expect(page).to have_content('1.2')
        expect(page).to have_content('1.3')
        expect(page).to have_content('1.4')
    end

    scenario 'and returns to car categories home page' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Categorias de carro'

        click_on 'T1'

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