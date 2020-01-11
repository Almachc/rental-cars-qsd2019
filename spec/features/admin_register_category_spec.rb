require 'rails_helper'

feature 'Admin register car_category' do
    scenario 'successfully' do
        #Act
        visit root_path
        click_on 'Categorias de carro'

        click_on 'Registrar nova categoria de carro'

        fill_in 'Nome', with: 'T1'
        fill_in 'Diária', with: '1.2'
        fill_in 'Seguro do carro', with: '1.3'
        fill_in 'Seguro contra terceiros', with: '1.4'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Categoria criada com sucesso')
        expect(page).to have_content('T1')
    end

    scenario 'all fields must be filled' do
        #Act
        visit root_path
        click_on 'Categorias de carro'

        click_on 'Registrar nova categoria de carro'

        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Nome deve ser preenchido')
        expect(page).to have_content('Diária deve ser preenchido')
        expect(page).to have_content('Seguro do carro deve ser preenchido')
        expect(page).to have_content('Seguro contra terceiros deve ser preenchido')
    end

    scenario 'and Daily Rate, car insurance and third party insurance must be greater than zero' do
        #Act
        visit root_path
        click_on 'Categorias de carro'

        click_on 'Registrar nova categoria de carro'

        fill_in 'Nome', with: 'T1'
        fill_in 'Diária', with: '0'
        fill_in 'Seguro do carro', with: '0'
        fill_in 'Seguro contra terceiros', with: '0'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Diária deve ser maior que zero')
        expect(page).to have_content('Seguro do carro deve ser maior que zero')
        expect(page).to have_content('Seguro contra terceiros deve ser maior que zero')
    end
end