require 'rails_helper'

feature 'User searches rentals' do
    scenario 'by exact code' do
        #Arrange
        user = create(:user)

        client = create(:client)
        car_category = create(:car_category)
        rental = create(:rental, code: 'CIC3301', client: client, car_category: car_category, user: user)
        create(:rental, code: 'CIC2020', client: client, car_category: car_category, user: user)
        create(:rental, code: 'JUL1947', client: client, car_category: car_category, user: user)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Locações'
        fill_in 'Pesquisar', with: 'CIC3301'
        click_on 'Buscar'

        #Assert
        expect(page).to_not have_content('CIC2020')
        expect(page).to_not have_content('JUL1947')

        expect(page).to have_content("Foram encontrado(s) 1 resultado(s)")
        expect(page).to have_content(rental.code)
        expect(page).to have_content(rental.start_date)
        expect(page).to have_content(rental.end_date)
        expect(page).to have_content(client.name)
        expect(page).to have_content(car_category.name)
    end

    scenario 'by partial code' do
        #Arrange
        user = create(:user)

        client = create(:client)
        car_category = create(:car_category)
        rental = create(:rental, code: 'CIC3301', client: client, car_category: car_category, user: user)
        create(:rental, code: 'CIC2020', client: client, car_category: car_category, user: user)
        create(:rental, code: 'JUL1947', client: client, car_category: car_category, user: user)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Locações'
        fill_in 'Pesquisar', with: 'cic'
        click_on 'Buscar'

        #Assert
        expect(page).to_not have_content('JUL1947')

        expect(page).to have_content("Foram encontrado(s) 2 resultado(s)")
        expect(page).to have_content('CIC3301')
        expect(page).to have_content('CIC2020')
        expect(page).to have_content(rental.start_date)
        expect(page).to have_content(rental.end_date)
        expect(page).to have_content(client.name)
        expect(page).to have_content(car_category.name)
    end

    scenario 'by no code (must bring everyone)' do
        #Arrange
        user = create(:user)

        client = create(:client)
        car_category = create(:car_category)
        rental = create(:rental, code: 'CIC3301', client: client, car_category: car_category, user: user)
        create(:rental, code: 'CIC2020', client: client, car_category: car_category, user: user)
        create(:rental, code: 'JUL1947', client: client, car_category: car_category, user: user)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Locações'
        fill_in 'Pesquisar', with: ' '
        click_on 'Buscar'

        #Assert
        expect(page).to have_content("Foram encontrado(s) 3 resultado(s)")
        expect(page).to have_content('CIC3301')
        expect(page).to have_content('CIC2020')
        expect(page).to have_content('JUL1947')
        expect(page).to have_content(rental.start_date)
        expect(page).to have_content(rental.end_date)
        expect(page).to have_content(client.name)
        expect(page).to have_content(car_category.name)
    end

    scenario 'and no results are found' do
        #Arrange
        user = create(:user)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Locações'
        fill_in 'Pesquisar', with: 'cic'
        click_on 'Buscar'

        #Assert
        expect(page).to have_content('Nenhum resultado encontrado para o seguinte código: cic')
        expect(current_path).to eq(rentals_path)
    end

    scenario 'and back to the rentals home page' do
        #Arrange
        user = create(:user)

        create(:rental)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Locações'

        fill_in 'Pesquisar', with: 'cic3301'
        click_on 'Buscar'

        click_on 'Voltar'

        #Assert
        expect(current_path).to eq(rentals_path)
    end
end