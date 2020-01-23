require 'rails_helper'

feature 'User registers rental' do
    scenario 'successfully' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')

        manufacturer = Manufacturer.create!(name: 'Fabricante1')
        car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
        car_model = CarModel.create!(name: 'Modelo1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')
        car = Car.create!(license_plate: 'ABC1234', color: 'Branco', car_model: car_model, mileage: '200')

        client = Client.create!(name: 'Cliente1', cpf: '42074026838', email: 'cliente1@gmail.com')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Locações'
        
        click_on 'Registrar nova locação'

        fill_in 'Data de início', with: Date.current.strftime('%d/%m/%Y')
        fill_in 'Data de término', with: 1.day.from_now.strftime('%d/%m/%Y')
        select 'Cliente1', from: 'Cliente'
        select 'Categoria1', from: 'Categoria de carro'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Locação agendada com sucesso')
        #expect(Rental.last.code).to match(/[a-zA-Z0-9]+/)
        expect(page).to have_content(Date.current.strftime('%d/%m/%Y'))
        expect(page).to have_content(1.day.from_now.strftime('%d/%m/%Y'))
        expect(page).to have_content('Cliente1')
        expect(page).to have_content('Categoria1')
        expect(page).to have_content(user.email)
    end

    scenario '(dates must be valid)' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')

        manufacturer = Manufacturer.create!(name: 'Fabricante1')
        car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
        car_model = CarModel.create!(name: 'Modelo1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')
        car = Car.create!(license_plate: 'ABC1234', color: 'Branco', car_model: car_model, mileage: '200')
        client = Client.create!(name: 'Cliente1', cpf: '42074026838', email: 'cliente1@gmail.com')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Locações'
        
        click_on 'Registrar nova locação'

        fill_in 'Data de início', with: 1.day.ago.strftime('%d/%m/%Y')
        fill_in 'Data de término', with: 2.days.ago.strftime('%d/%m/%Y')
        select 'Cliente1', from: 'Cliente'
        select 'Categoria1', from: 'Categoria de carro'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Data inicial não deve estar no passado')
        expect(page).to have_content('Data final deve ser maior que a data inicial')
       
        expect(page).to have_field('Data de início', with: 1.day.ago.strftime('%d/%m/%Y'))
        expect(page).to have_field('Data de término', with: 2.days.ago.strftime('%d/%m/%Y'))
        expect(page).to have_select('Cliente', selected: 'Cliente1')
        expect(page).to have_select('Categoria', selected: 'Categoria1')
    end

    scenario '(cars must be available)' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')

        car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
        client = Client.create!(name: 'Cliente1', cpf: '42074026838', email: 'cliente1@gmail.com')

        Rental.create!(code: 'cic3301', start_date: Date.current, end_date: 1.day.from_now, client: client, car_category: car_category, user: user)

        manufacturer = Manufacturer.create!(name: 'Fabricante1')
        car_model = CarModel.create!(name: 'Modelo1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')
        car = Car.create!(license_plate: 'ABC1234', color: 'Branco', car_model: car_model, mileage: '200')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Locações'
        
        click_on 'Registrar nova locação'

        fill_in 'Data de início', with: Date.current.strftime('%d/%m/%Y')
        fill_in 'Data de término', with: 1.day.from_now.strftime('%d/%m/%Y')
        select 'Cliente1', from: 'Cliente'
        select 'Categoria1', from: 'Categoria de carro'
        click_on 'Enviar'

        #Assert
        expect(page).to have_content('Carros indisponíveis para esta categoria')
    end
end