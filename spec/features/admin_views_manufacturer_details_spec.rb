require 'rails_helper'

feature 'Admin views manufacturer details' do
    scenario 'successfully' do
        #Arrange
        Manufacturer.create!(name: 'Fiat')

        #Act
        visit root_path
        click_on 'Fabricantes'

        click_on 'Fiat'

        #Assert
        expect(page).to have_content('Fiat')
    end

    scenario 'and returns to manufacturers home page' do
        #Arrange
        Manufacturer.create!(name: 'Fiat')

        #Act
        visit root_path
        click_on 'Fabricantes'

        click_on 'Fiat'

        click_on 'Voltar'
    
        #Assert
        expect(current_path).to eq manufacturers_path
    end
end