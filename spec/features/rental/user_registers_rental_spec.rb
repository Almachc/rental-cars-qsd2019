require 'rails_helper'

feature 'User registers rental' do
    scenario 'successfully' do
        #Arrange
        user = create(:user)

        #Uma outra opção seria fazer somente: create(:car)
        #Com a criação do carro, consequentemente também seria criado um car_model que, por sua vez, 
        #seria então responsável pela criação de um car_category
        car_category = create(:car_category)
        car_model = create(:car_model, car_category: car_category)
        create(:car, car_model: car_model)
        create(:client)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Locações'
        
        click_on 'Registrar nova locação'

        fill_in 'Data de início', with: Date.current.strftime('%d/%m/%Y')
        fill_in 'Data de término', with: 1.day.from_now.strftime('%d/%m/%Y')
        select 'Leopoldo', from: 'Cliente'
        select 'catA', from: 'Categoria de carro'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Locação agendada com sucesso')
        #expect(Rental.last.code).to match(/[a-zA-Z0-9]+/)
        expect(page).to have_content(Date.current.strftime('%d/%m/%Y'))
        expect(page).to have_content(1.day.from_now.strftime('%d/%m/%Y'))
        expect(page).to have_content('Leopoldo')
        expect(page).to have_content('catA')
        expect(page).to have_content(user.email)
    end

    scenario '(dates must be valid)' do
        #Arrange
        user = create(:user)

        car_category = create(:car_category, name: 'catA')
        create(:car_category, name: 'catB')
        car_model = create(:car_model, car_category: car_category)
        create(:car, car_model: car_model)
        create(:cliente, name: 'Leopoldo')
        create(:client, name: 'Goku')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Locações'
        
        click_on 'Registrar nova locação'

        fill_in 'Data de início', with: 1.day.ago.strftime('%d/%m/%Y')
        fill_in 'Data de término', with: 2.days.ago.strftime('%d/%m/%Y')
        select 'Leopoldo', from: 'Cliente'
        select 'catA', from: 'Categoria de carro'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Data inicial não deve estar no passado')
        expect(page).to have_content('Data final deve ser maior que a data inicial')
       
        expect(page).to have_field('Data de início', with: 1.day.ago.strftime('%d/%m/%Y'))
        expect(page).to have_field('Data de término', with: 2.days.ago.strftime('%d/%m/%Y'))
        expect(page).to have_select('Cliente', selected: 'Leopoldo')
        expect(page).to have_content('Goku')
        expect(page).to have_select('Categoria', selected: 'catA')
        expect(page).to have_content('catB')
    end

    scenario '(cars must be available)' do
        #Arrange
        user = create(:user)

        car_category = create(:car_category)
        
        car_model = create(:car_model, car_category: car_category)
        create(:car, car_model: car_model)
        client = create(:client)
        create(:rental, client: client, car_category: car_category, user: user)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Locações'
        
        click_on 'Registrar nova locação'

        fill_in 'Data de início', with: Date.current.strftime('%d/%m/%Y')
        fill_in 'Data de término', with: 1.day.from_now.strftime('%d/%m/%Y')
        select 'Leopoldo', from: 'Cliente'
        select 'catA', from: 'Categoria de carro'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Carros indisponíveis para esta categoria')
    end

    scenario '(must be authenticated to access the register form)' do
        #Act
        visit new_rental_path

        #Assert
        expect(current_path).to eq new_user_session_path
    end

    scenario '(must be authenticated to register it)' do
        #Act
        page.driver.submit :post, rentals_path, {}

        #Assert
        expect(current_path).to eq new_user_session_path
    end
end