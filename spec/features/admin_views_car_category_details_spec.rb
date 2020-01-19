require 'rails_helper'

feature 'Admin views car category details' do
    scenario 'successfully' do
        #Arrange
        CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
        
        #Act
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
        CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)

        #Act
        visit root_path
        click_on 'Categorias de carro'

        click_on 'T1'

        click_on 'Voltar'

        #Assert
        expect(current_path).to eq car_categories_path
    end
end