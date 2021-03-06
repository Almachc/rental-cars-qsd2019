require 'rails_helper'

feature 'User view rental details' do
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
        expect(page).to have_content(I18n.l(rental.start_date, format: I18n.t('date.formats.default')))
        expect(page).to have_content(I18n.l(rental.end_date, format: I18n.t('date.formats.default')))
        expect(page).to have_content(rental.client.name)
        expect(page).to have_content(rental.car_category.name)
        expect(page).to have_content(rental.user.email)
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