require 'rails_helper'

feature 'Admin view car_categories' do
    scenario 'successfully' do
        #Arrange
        CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
        CarCategory.create!(name: 'T2', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)

        #Act
        visit root_path
        click_on 'Categorias de carro'
        click_on 'T2'

        #Assert
        expect(page).to have_content('T2')
        expect(page).to have_content('1.2')
        expect(page).to have_content('1.3')
        expect(page).to have_content('1.4')
        expect(page).to have_link('Voltar')
    end

    scenario 'and return to home page' do
        CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
        CarCategory.create!(name: 'T2', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
    
        visit root_path
        click_on 'Categorias de carro'
        click_on 'T1'
        click_on 'Voltar'
    
        expect(current_path).to eq root_path
    end
end