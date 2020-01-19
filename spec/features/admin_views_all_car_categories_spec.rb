require 'rails_helper'

feature 'Admin views all car categories' do
    scenario 'successfully' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
        CarCategory.create!(name: 'T2', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Categorias de carro'

        #Assert
        expect(page).to have_content('T1')
        expect(page).to have_content('T2')
    end

    scenario 'and returns to home page' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')

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