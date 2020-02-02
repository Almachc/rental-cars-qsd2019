require 'rails_helper'

feature 'User view rental details'
    scenario 'successfully ' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        client = Client.create!(name: 'Cliente1', cpf: '42074026838', email: 'cliente1@gmail.com')
        car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
        rental = Rental.create!(code: 'cic3301', start_date: Date.current, end_date: 1.day.from_now, client: client, car_category: car_category, user: user)
        
        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Locações'

        fill_in 'Pesquisar', with: 'cic'
        click_on 'Buscar'

        within("tr#rental-#{rental.id}") do
            click_on 'Visualizar'
        end

        #Assert
        expect(page).to have_content(rental.code)
        expect(page).to have_content(rental.start_date)
        expect(page).to have_content(rental.end_date)
        expect(page).to have_content(rental.client)
        expect(page).to have_content(rental.car_category)
        expect(page).to have_content(rental.user)
    end

    scenario 'and back to the search page' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        client = Client.create!(name: 'Cliente1', cpf: '42074026838', email: 'cliente1@gmail.com')
        car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
        rental = Rental.create!(code: 'cic3301', start_date: Date.current, end_date: 1.day.from_now, client: client, car_category: car_category, user: user)
        
        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Locações'

        fill_in 'Pesquisar', with: 'cic'
        click_on 'Buscar'

        within("tr#rental-#{rental.id}") do
            click_on 'Visualizar'
        end

        click_on 'Voltar'

        #Assert
        expect(current_path).to eq(search_rentals_path)
    end

    scenario '(must be authenticated to have access from the url)' do
        #Act
        visit rental_path(000)

        #Assert
        expect(current_path).to eq(new_user_session_path)
    end
end