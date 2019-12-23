require 'rails_helper'

feature 'Admin delete category' do
    scenario 'successfully' do
        #Arrange
        CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)

        #Act
        visit root_path
        click_on 'Categorias de carro'
        click_on 'T1'
        click_on 'Deletar'

        #Assert
        expect(page).to have_content('Categoria deletada com sucesso')
        expect(page).to have_no_content('T1')
    end
end