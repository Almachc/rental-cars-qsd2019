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
            click_on 'Efetivar locação'
        end

        select 'ABC1234', from: 'Carro'
        click_on 'Efetivar'
      
        #Assert
        expect(page).to have_content("Locação: cic3301")
        expect(page).to have_content('Cliente: Cliente1 - 42074026838')
        expect(page).to have_content('Carro: Fabricante1 / Modelo1 - ABC1234 - Branco')
        expect(page).to have_content('Quilometragem: 200')
        expect(page).to have_content('Preço: 1.2')
        expect(car.reload.status).to eq 'unavailable'
    end
end