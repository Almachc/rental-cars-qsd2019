require 'rails_helper'

feature 'Admin registers car category' do
    scenario 'successfully' do
        #Arrange
        user = create(:user)
        
        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Categorias de carro'

        click_on 'Registrar nova categoria de carro'

        fill_in 'Nome', with: 'catA'
        fill_in 'Diária', with: '400.99'
        fill_in 'Seguro do carro', with: '700.99'
        fill_in 'Seguro contra terceiros', with: '800.99'
        click_on 'Enviar'

        #Assert
        expect(CarCategory.count).to eq 1
        car_category = CarCategory.first
        expect(CarCategory.first).to have_attributes(name: 'catA', daily_rate: 400.99,
                                                     car_insurance: 700.99,
                                                     third_party_insurance: 800.99)

        expect(current_path).to eq(car_category_path(car_category))

        expect(page).to have_content('Categoria registrada com sucesso')
        expect(page).to have_content('catA')
        expect(page).to have_content('400.99')
        expect(page).to have_content('700.99')
        expect(page).to have_content('800.99')
    end

    scenario '(all fields must be filled)' do
        #Arrange
        user = create(:user)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Categorias de carro'

        click_on 'Registrar nova categoria de carro'

        click_on 'Enviar'

        #Assert
        expect(CarCategory.count).to eq 0

        expect(page).to have_content('Nome não pode ficar em branco')
        expect(page).to have_content('Diária não pode ficar em branco')
        expect(page).to have_content('Seguro do carro não pode ficar em branco')
        expect(page).to have_content('Seguro contra terceiros não pode ficar em branco')
    end

    scenario '(daily Rate, car insurance and third party insurance must be greater than zero)' do
        #Arrange
        user = create(:user)
        
        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Categorias de carro'

        click_on 'Registrar nova categoria de carro'

        fill_in 'Nome', with: 'catA'
        fill_in 'Diária', with: '0'
        fill_in 'Seguro do carro', with: '0'
        fill_in 'Seguro contra terceiros', with: '0'
        click_on 'Enviar'

        #Assert
        expect(CarCategory.count).to eq 0

        expect(page).to have_field('Nome', with: 'catA')
        expect(page).to have_field('Diária', with: '0')
        expect(page).to have_field('Seguro do carro', with: '0')
        expect(page).to have_field('Seguro contra terceiros', with: '0')

        expect(page).to have_content('Diária deve ser maior que 0')
        expect(page).to have_content('Seguro do carro deve ser maior que 0')
        expect(page).to have_content('Seguro contra terceiros deve ser maior que 0')
    end

    scenario '(must be authenticated to have access to the create form)' do
        #Act
        visit new_car_category_path

        #Assert
        expect(current_path).to eq new_user_session_path
    end

    scenario '(must be authenticated to create it)' do
        #Act
        page.driver.submit :post, car_categories_path, {}
        
        #Assert
        expect(current_path).to eq new_user_session_path
    end
end