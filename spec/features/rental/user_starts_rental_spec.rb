require 'rails_helper'

feature 'User starts rental' do
    scenario 'successfully' do
        #Arrange
        user = create(:user)
        client = create(:client)
        car_category = create(:car_category)
        rental = create(:rental, code: 'CIC3301', client: client, car_category: car_category, user: user)
        create(:rental, code: 'CIC3333', client: client, car_category: car_category, user: user)

        car_model = create(:car_model, car_category: car_category)
        car = create(:car, car_model: car_model)

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

        select car.license_plate, from: 'Carro'
        click_on 'Efetivar'
      
        #Assert
        expect(page).to have_content("Locação: #{rental.code}")
        expect(page).to have_content("Cliente: #{rental.client.name} - #{rental.client.cpf}")
        expect(page).to have_content("Carro: #{car.full_description}")
        expect(page).to have_content("Quilometragem inicial: #{car.mileage}")
        expect(page).to have_content("Preço: #{rental.car_category.total_price}")
    end

    scenario '(must be authenticated to access the form with valid cars)' do
        #Act
        visit start_rental_path('whatever')

        #Assert
        expect(current_path).to eq new_user_session_path
    end

    scenario '(only available cars should be displayed)' do
        #Arrange
        user = create(:user)
        manufacturer = create(:manufacturer)

        car_category1 = create(:car_category, name: 'catA')
        car_model1 = create(:car_model, name: 'HB20', car_category: car_category1,
                            manufacturer: manufacturer)
        
        car_category2 = create(:car_category, name: 'catB')
        car_model2 = create(:car_model, name: 'Azera', car_category: car_category2,
                            manufacturer: manufacturer)
        
        create(:car, car_model: car_model1, license_plate: 'ABC1234')
        create(:car, car_model: car_model1, license_plate: 'SLA9999')
        create(:car, car_model: car_model2, license_plate: 'FDM2000')

        client = create(:client)
        rental = create(:rental, code: 'CIC3333', client: client, car_category: car_category1, user: user)
        
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
        user = create(:user)
        car = create(:car)
        rental = create(:rental, user: user)
        car_rental = CarRental.new(rental_id: rental.id, car_id: car.id, price: nil, start_mileage: nil, end_mileage: nil)
       
        #Act
        car_rental.valid?

        #Assert
        expect(car_rental.errors.messages[:price]).to include('O preço (baseado no custo atual da categoria) é obrigatório')
        expect(car_rental.errors.messages[:start_mileage]).to include('A quilometragem inicial (baseada na quilometragem atual do carro) é obrigatória')
    end
end