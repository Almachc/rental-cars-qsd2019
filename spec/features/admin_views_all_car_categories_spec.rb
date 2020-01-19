require 'rails_helper'

feature 'Admin views all car categories' do
    scenario 'successfully' do
        #Arrange
        CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
        CarCategory.create!(name: 'T2', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)

        #Act
        visit root_path
        click_on 'Categorias de carro'

        #Assert
        expect(page).to have_content('T1')
        expect(page).to have_content('T2')
    end

    scenario 'and returns to home page' do
        visit root_path
        click_on 'Categorias de carro'
        click_on 'Voltar'
    
        expect(current_path).to eq root_path
    end
end