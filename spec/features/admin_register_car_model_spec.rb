require 'rails_helper'

feature 'Admin register car_model' do
    scenario 'successfully' do
        #Arrange
        Manufacturer.create(name: 'Fiat')
        CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)

        #Act
        visit root_path
        click_on 'Modelos de carro'
        click_on 'Cadastrar novo modelo'
        
        fill_in 'Nome', with: 'ModeloTeste1'
        fill_in 'Ano', with: '2019'
        select 'Fiat', from: 'Fabricante'
        fill_in 'Cavalos', with: '50'
        select 'T1', from: 'Categoria'
        fill_in 'Tipo de combustível', with: 'Etanol'

        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Modelo cadastrado com sucesso')
        expect(page).to have_content('ModeloTeste1')
        expect(page).to have_content('2019')
        expect(page).to have_content('Fiat')
        expect(page).to have_content('50')
        expect(page).to have_content('T1')
        expect(page).to have_content('Etanol')
    end

    scenario 'all fields must be filled' do
        #Act
        visit root_path
        click_on 'Modelos de carro'
        click_on 'Cadastrar novo modelo'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Nome não deve ficar em branco')
        expect(page).to have_content('Ano não deve ficar em branco')
        expect(page).to have_content('Fabricante não deve ficar em branco')    
        expect(page).to have_content('Cavalos não deve ficar em branco')
        expect(page).to have_content('Categoria não deve ficar em branco')
        expect(page).to have_content('Tipo de combustível não deve ficar em branco')
    end
end