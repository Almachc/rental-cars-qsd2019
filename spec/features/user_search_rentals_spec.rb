require 'rails_helper'

feature 'User search rentals' do
    scenario 'by exact code' do
        #Arrange
        user = User.create!(email: 'usuario1@gmail.com', password: '123456')

        client = Client.create!(name: 'Cliente1', cpf: '42074026838', email: 'cliente1@gmail.com')
        car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
        Rental.create!(code: 'cic3301', start_date: Date.current, end_date: 1.day.from_now, client: client, car_category: car_category)
        Rental.create!(code: 'cic2020', start_date: Date.current, end_date: 1.day.from_now, client: client, car_category: car_category)
        Rental.create!(code: 'jul1947', start_date: Date.current, end_date: 1.day.from_now, client: client, car_category: car_category)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Locações'
        fill_in 'Pesquisar', with: 'cic3301'
        click_on 'Buscar'

        #Assert
        expect(page).to_not have_content('cic2020')
        expect(page).to_not have_content('jul1947')
        
        expect(page).to have_content('cic3301')
        expect(page).to have_content(Date.current.strftime('%d/%m/%Y'))
        expect(page).to have_content(1.day.from_now.strftime('%d/%m/%Y'))
        expect(page).to have_content(client.name)
        expect(page).to have_content(car_category.name)
    end

    scenario 'by partial code' do
        #Arrange
        user = User.create!(email: 'usuario1@gmail.com', password: '123456')

        client = Client.create!(name: 'Cliente1', cpf: '42074026838', email: 'cliente1@gmail.com')
        car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
        Rental.create!(code: 'cic3301', start_date: Date.current, end_date: 1.day.from_now, client: client, car_category: car_category)
        Rental.create!(code: 'cic2020', start_date: Date.current, end_date: 1.day.from_now, client: client, car_category: car_category)
        Rental.create!(code: 'jul1947', start_date: Date.current, end_date: 1.day.from_now, client: client, car_category: car_category)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Locações'
        fill_in 'Pesquisar', with: 'cic'
        click_on 'Buscar'

        #Assert
        expect(page).to_not have_content('jul1947')
        
        expect(page).to have_content('cic3301')
        expect(page).to have_content('cic2020')
        expect(page).to have_content(Date.current.strftime('%d/%m/%Y'))
        expect(page).to have_content(1.day.from_now.strftime('%d/%m/%Y'))
        expect(page).to have_content(client.name)
        expect(page).to have_content(car_category.name)
    end
end