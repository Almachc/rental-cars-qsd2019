require 'rails_helper'

describe 'Car management' do
    context '- index / list: ' do
        it 'should be render a JSON with all cars' do
            #Arrange
            manufacturer = Manufacturer.create!(name: 'Fabricante1')
            car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
            car_model = CarModel.create!(name: 'Modelo1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')
            car1 = Car.create!(license_plate: 'ABC1234', color: 'Branco', car_model: car_model, mileage: '200')
            car2 = Car.create!(license_plate: 'ABC9999', color: 'Preto', car_model: car_model, mileage: '200')
            car3 = Car.create!(license_plate: 'CIC3301', color: 'Bronze', car_model: car_model, mileage: '200')
            
            #Act
            get api_v1_cars_path

            converted_json = JSON.parse(response.body, symbolize_names: true)

            #Assert
            expect(response).to have_http_status(:ok)
            expect(converted_json[0][:license_plate]).to eq(car1.license_plate)
        end
    end

    context '- show: ' do
        it 'should be render a JSON with details of a specific car' do
            #Arrange
            manufacturer = Manufacturer.create(name: 'Fabricante1')
            car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
            car_model = CarModel.create!(name: 'Modelo1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')
            car = Car.create!(license_plate: 'ABC1234', color: 'Branco', car_model: car_model, mileage: '200')

            #Act
            get api_v1_car_path(car)

            converted_json = JSON.parse(response.body, symbolize_names: true)
        
            #Assert
            expect(response).to have_http_status(:ok)
            expect(converted_json[:license_plate]).to eq(car.license_plate)
            expect(converted_json[:color]).to eq(car.color)
            expect(converted_json[:car_model_id]).to eq(car.car_model_id)
            expect(converted_json[:mileage]).to eq(car.mileage)
            expect(converted_json[:status]).to eq(car.status)
        end
    end

    context '- post: ' do
        it 'should be create a car and render a JSON with its details' do
            #Arrange
            manufacturer = Manufacturer.create(name: 'Fabricante1')
            car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
            car_model = CarModel.create!(name: 'Modelo1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')

            #Act
            post api_v1_cars_path, params: { :car => { license_plate: 'ABC1234', color: 'Branco', car_model_id: car_model.id, mileage: '200' } }
            
            converted_json = JSON.parse(response.body, symbolize_names: true)
        
            #Assert
            car = Car.last
            expect(car.license_plate).to eq('ABC1234')
            expect(car.color).to eq('Branco')
            expect(car.car_model_id).to eq(car_model.id)
            expect(car.mileage).to eq(200)

            expect(response).to have_http_status(:ok)
            expect(converted_json[:license_plate]).to eq(car.license_plate)
            expect(converted_json[:color]).to eq(car.color)
            expect(converted_json[:car_model_id]).to eq(car.car_model_id)
            expect(converted_json[:mileage]).to eq(car.mileage)
            expect(converted_json[:status]).to eq(car.status)
        end
    end

    context '- update: '
        it 'should be update a car and render a JSON with its details' do
            
        end
end