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

        fill_in 'Nome', with: 'T1'
        fill_in 'Diária', with: ''
        fill_in 'Seguro do carro', with: '1.3'
        fill_in 'Seguro contra terceiros', with: '1.4'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Todos os campos devem ser preenchidos')
    end
end