require 'rails_helper'

feature 'Admin edits car category' do
    scenario 'successfully' do
        #Arrange
        user = create(:user)
        car_category = create(:car_category)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Categorias de carro'
        click_on 'catA'
        click_on 'Editar'

        fill_in 'Nome', with: 'catB'
        fill_in 'Seguro do carro', with: '700'
        click_on 'Enviar'

        #Assert
        expect(car_category.reload).to have_attributes(name: 'catB', car_insurance: 700)

        expect(current_path).to eq car_category_path(car_category)
        
        expect(page).to have_content('Categoria editada com sucesso')
        expect(page).to have_content('catB')
        expect(page).to have_content(car_category.daily_rate)
        expect(page).to have_content('700')
        expect(page).to have_content(car_category.third_party_insurance)
    end

    scenario '(all fields must be filled)' do
       #Arrange
       user = create(:user)
       create(:car_category)

       #Act
       login_as(user, scope: :user)
       visit root_path
       click_on 'Categorias de carro'
       click_on 'catA'
       click_on 'Editar'

       fill_in 'Nome', with: ''
       fill_in 'Diária', with: ''
       fill_in 'Seguro do carro', with: ''
       fill_in 'Seguro contra terceiros', with: ''
       click_on 'Enviar'

        #Assert
        expect(CarCategory.first).to_not have_attributes(name: '', daily_rate: '',
                                                         car_insurance: '',
                                                         third_party_insurance: '')

        expect(page).to have_content('Nome deve ser preenchido')
        expect(page).to have_content('Diária deve ser preenchido')
        expect(page).to have_content('Seguro do carro deve ser preenchido')
        expect(page).to have_content('Seguro contra terceiros deve ser preenchido')
    end

    scenario '(daily rate, car insurance and third party insurance must be greater than zero)' do
        #Arrange
        user = create(:user)
        create(:car_category)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Categorias de carro'

        click_on 'catA'

        click_on 'Editar'

        fill_in 'Diária', with: '0'
        fill_in 'Seguro do carro', with: '0'
        fill_in 'Seguro contra terceiros', with: '0'
        click_on 'Enviar'

        #Assert
        expect(CarCategory.first).to_not have_attributes(daily_rate: 0,
                                                         car_insurance: 0,
                                                         third_party_insurance: 0)

        expect(page).to have_field('Nome', with: 'catA')
        expect(page).to have_field('Diária', with: '0')
        expect(page).to have_field('Seguro do carro', with: '0')
        expect(page).to have_field('Seguro contra terceiros', with: '0')

        expect(page).to have_content('Diária deve ser maior que zero')
        expect(page).to have_content('Seguro do carro deve ser maior que zero')
        expect(page).to have_content('Seguro contra terceiros deve ser maior que zero')
    end

    scenario '(must be authenticated to have access to the edit form)' do
        #Act
        visit edit_car_category_path(3301)

        #Assert
        expect(current_path).to eq new_user_session_path
    end

    scenario '(must be authenticated to edit it)' do
        #Act
        page.driver.submit :patch, car_category_path(3301), {}

        #Assert
        expect(current_path).to eq new_user_session_path
    end
end