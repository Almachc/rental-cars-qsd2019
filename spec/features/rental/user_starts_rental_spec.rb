require 'rails_helper'

feature 'User starts rental' do
    scenario 'successfully' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        client = Client.create!(name: 'Cliente1', cpf: '42074026838', email: 'cliente1@gmail.com')
        car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
        rental = Rental.create!(code: 'cic3301', start_date: Date.current, end_date: 1.day.from_now, client: client, car_category: car_category, user: user)
        Rental.create!(code: 'cic3333', start_date: Date.current, end_date: 1.day.from_now, client: client, car_category: car_category, user: user)

        manufacturer = Manufacturer.create(name: 'Fabricante1')
        car_model = CarModel.create!(name: 'Modelo1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')
        car = Car.create!(license_plate: 'ABC1234', color: 'Branco', car_model: car_model, mileage: '200')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Locações'
        
        fill_in 'Pesquisar', with: 'cic'
        click_on 'Buscar'

        within("tr#rental-#{rental.id}") do
            click_on 'Visualizar'
        end
        
        click_on 'Efetivar locação'

        select 'ABC1234', from: 'Carro'
        click_on 'Efetivar'
      
        #Assert
        expect(page).to have_content("Locação: cic3301")
        expect(page).to have_content('Cliente: Cliente1 - 42074026838')
        expect(page).to have_content('Carro: Fabricante1 / Modelo1 - ABC1234 - Branco')
        expect(page).to have_content('Quilometragem: 200')
        expect(page).to have_content('Preço: 3.9')
        expect(car.reload.status).to eq 'unavailable'
    end

    scenario '(must be authenticated to access the form with valid cars)' do
        #Act
        visit start_rental_path(000)

        #Assert
        expect(current_path).to eq new_user_session_path
    end

    scenario '(only available cars should be displayed)' do
        #Arrange
        user = User.create!(email: 'usuario@gmail.com', password: '123456')

        manufacturer = Manufacturer.create!(name: 'Fabricante1')

        car_category1 = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
        car_model1 = CarModel.create!(name: 'Modelo1', year: '2019', motorization: '1.0', fuel_type: 'Etanol',
                                      car_category: car_category1, manufacturer: manufacturer)
        
        car_category2 = CarCategory.create!(name: 'Categoria2', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
        car_model2 = CarModel.create!(name: 'Modelo2', year: '2019', motorization: '1.6', fuel_type: 'Gasolina',
                                      car_category: car_category2, manufacturer: manufacturer)
        
        Car.create(car_model: car_model1, color: 'Branco', license_plate: 'ABC1234', mileage: 100)
        Car.create(car_model: car_model1, color: 'Branco', license_plate: 'SLA9999', mileage: 100)
        Car.create(car_model: car_model2, color: 'Preto', license_plate: 'FDM2000', mileage: 100)

        client = Client.create!(name: 'Cliente1', email: 'cliente1@gmail.com', cpf: '42074026838')
        rental = Rental.create!(code: 'cic3333', start_date: Date.current, end_date: 1.day.from_now, client: client, car_category: car_category1, user: user)
        
        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Locações'

        fill_in 'Pesquisar', with: 'cic'
        click_on 'Buscar'

        within("tr#rental-#{rental.id}") do
            click_on 'Visualizar'
        end
        
        click_on 'Efetivar locação'

        #Assert
        expect(page).to have_content('ABC1234')
        expect(page).to have_content('SLA9999')
        expect(page).not_to have_content('FDM2000')
    end

    scenario '(price and mileage must be obligatory)' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')

        car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)

        manufacturer = Manufacturer.create(name: 'Fabricante1')
        car_model = CarModel.create!(name: 'Modelo1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')
        car = Car.create!(license_plate: 'ABC1234', color: 'Branco', car_model: car_model, mileage: '200')

        client = Client.create!(name: 'Cliente1', cpf: '42074026838', email: 'cliente1@gmail.com')
        rental = Rental.create!(code: 'cic3301', start_date: Date.current, end_date: 1.day.from_now, client: client, car_category: car_category, user: user)

        car_rental = CarRental.new(rental_id: rental.id, car_id: car.id, price: nil, start_mileage: nil, end_mileage: nil)
       
        car_rental.valid?

        #Assert
        expect(car_rental.errors.messages[:price]).to include('O preço (baseado no custo atual da categoria) é obrigatório')
        expect(car_rental.errors.messages[:start_mileage]).to include('A quilometragem inicial (baseada na quilometragem atual do carro) é obrigatória')
    end
end