require 'rails_helper'

feature 'Admin edits car category' do
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
        expect(page).to have_content('T2')
        expect(page).to have_content('1.2')
        expect(page).to have_content('2.5')
        expect(page).to have_content('1.4')

        expect(page).to have_content('Categoria editada com sucesso')
    end

    scenario '(all fields must be filled)' do
       #Arrange
       CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)

       #Act
       visit root_path
       click_on 'Categorias de carro'
       click_on 'T1'
       click_on 'Editar'

       fill_in 'Nome', with: ''
       fill_in 'Diária', with: ''
       fill_in 'Seguro do carro', with: ''
       fill_in 'Seguro contra terceiros', with: ''
       click_on 'Enviar'

        #Assert
        expect(page).to have_content('Nome deve ser preenchido')
        expect(page).to have_content('Diária deve ser preenchido')
        expect(page).to have_content('Seguro do carro deve ser preenchido')
        expect(page).to have_content('Seguro contra terceiros deve ser preenchido')
    end

    scenario '(daily rate, car insurance and third party insurance must be greater than zero)' do
        #Arrange
        CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)

        #Act
        visit root_path
        click_on 'Categorias de carro'

        click_on 'T1'

        click_on 'Editar'

        fill_in 'Diária', with: '0'
        fill_in 'Seguro do carro', with: '0'
        fill_in 'Seguro contra terceiros', with: '0'
        click_on 'Enviar'

        #Assert
        expect(page).to have_field('Nome', with: 'T1')
        expect(page).to have_field('Diária', with: '0')
        expect(page).to have_field('Seguro do carro', with: '0')
        expect(page).to have_field('Seguro contra terceiros', with: '0')

        expect(page).to have_content('Diária deve ser maior que zero')
        expect(page).to have_content('Seguro do carro deve ser maior que zero')
        expect(page).to have_content('Seguro contra terceiros deve ser maior que zero')
    end
end