require 'rails_helper'

feature 'User view rental details'
    scenario 'successfully ' do
        #Arrange
        user = create(:user)
        client = create(:client)
        car_category = create(:car_category)
        rental = create(:rental, code: 'CIC3301', client: client, car_category: car_category, user: user)

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
        user = create(:user)
        client = create(:client)
        car_category = create(:car_category)
        rental = create(:rental, code: 'CIC3301', client: client, car_category: car_category, user: user)
        
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