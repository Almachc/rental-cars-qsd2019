require 'rails_helper'

feature 'Admin edit car_category' do
    scenario 'successfully' do
        #Arrange
        CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)

        #Act
        visit root_path
        click_on 'Categorias de carro'
        click_on 'T1'
        click_on 'Editar'

        fill_in 'Nome', with: 'T2'
        fill_in 'Seguro do carro', with: '2.5'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Categoria editada com sucesso')
        expect(page).to have_content('T2')
        expect(page).to have_content('2.5')
    end

    scenario 'all fields must be filled' do
       #Arrange
       CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)

       #Act
       visit root_path
       click_on 'Categorias de carro'
       click_on 'T1'
       click_on 'Editar'

       fill_in 'Nome', with: ''
       click_on 'Enviar'

        #Assert
        expect(page).to have_content('Todos os campos devem ser preenchidos')
    end
end