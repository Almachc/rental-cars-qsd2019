require 'rails_helper'

describe 'Car management' do
    context '- index / list: ' do
        it 'should render a JSON with all cars' do
            #Arrange
            manufacturer = Manufacturer.create!(name: 'Fabricante1')
            car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
            car_model = CarModel.create!(name: 'Modelo1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')
            car1 = Car.create!(license_plate: 'ABC1234', color: 'Branco', car_model: car_model, mileage: '200')
            car2 = Car.create!(license_plate: 'ABC9999', color: 'Preto', car_model: car_model, mileage: '200')
            car3 = Car.create!(license_plate: 'CIC3301', color: 'Bronze', car_model: car_model, mileage: '200')
            
            #Act
            get api_v1_cars_path

            #Assert
            converted_json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:ok) 
            expect(converted_json[0][:license_plate]).to eq(car1.license_plate)
            expect(converted_json[1][:license_plate]).to eq(car2.license_plate)
            expect(converted_json[2][:license_plate]).to eq(car3.license_plate)
        end

        it 'no car should be found' do
            #Act
            get api_v1_cars_path

            #Assert
            converted_json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:not_found) 
            expect(converted_json[:notice]).to eq('Nenhum resultado encontrado')
        end

        it 'should returned a server error (500)' do
            #Arrange
            manufacturer = Manufacturer.create!(name: 'Fabricante1')
            car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
            car_model = CarModel.create!(name: 'Modelo1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')
            car1 = Car.create!(license_plate: 'ABC1234', color: 'Branco', car_model: car_model, mileage: '200')
            car2 = Car.create!(license_plate: 'ABC9999', color: 'Preto', car_model: car_model, mileage: '200')
            car3 = Car.create!(license_plate: 'CIC3301', color: 'Bronze', car_model: car_model, mileage: '200')
            
            allow(Car).to receive(:all).and_raise(ActiveRecord::ConnectionNotEstablished)
            
            #Act
            get api_v1_cars_path

            #Assert
            converted_json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:internal_server_error) 
            expect(converted_json[:notice]).to eq('ActiveRecord::ConnectionNotEstablished')
        end
    end

    context '- show: ' do
        it 'should render a JSON with details of a specific car' do
            #Arrange
            manufacturer = Manufacturer.create(name: 'Fabricante1')
            car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
            car_model = CarModel.create!(name: 'Modelo1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')
            car = Car.create!(license_plate: 'ABC1234', color: 'Branco', car_model: car_model, mileage: '200')

            #Act
            get api_v1_car_path(car)
        
            #Assert
            converted_json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:ok)
            expect(converted_json[:license_plate]).to eq(car.license_plate)
            expect(converted_json[:color]).to eq(car.color)
            expect(converted_json[:car_model_id]).to eq(car.car_model_id)
            expect(converted_json[:mileage]).to eq(car.mileage)
            expect(converted_json[:status]).to eq(car.status)
        end

        it 'no car should be found' do
            #Act
            get api_v1_car_path(000)

            #Assert
            converted_json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:not_found)
            expect(converted_json[:notice]).to eq("Couldn't find Car with 'id'=0")
        end

        it 'should returned a server error (500)' do
            #Arrange
            manufacturer = Manufacturer.create(name: 'Fabricante1')
            car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
            car_model = CarModel.create!(name: 'Modelo1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')
            car = Car.create!(license_plate: 'ABC1234', color: 'Branco', car_model: car_model, mileage: '200')

            allow(Car).to receive(:find).and_raise(ActiveRecord::ConnectionNotEstablished)

            #Act
            get api_v1_car_path(car)

            #Assert
            converted_json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:internal_server_error)
            expect(converted_json[:notice]).to eq('ActiveRecord::ConnectionNotEstablished')
        end
    end

    context '- create: ' do
        it 'should create a car and render a JSON with its details' do
            #Arrange
            manufacturer = Manufacturer.create(name: 'Fabricante1')
            car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
            car_model = CarModel.create!(name: 'Modelo1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')

            #Act
            post api_v1_cars_path, params: { car: { license_plate: 'ABC1234', color: 'Branco', car_model_id: car_model.id, mileage: '200' } }
        
            #Assert
            converted_json = JSON.parse(response.body, symbolize_names: true)

            car = Car.last
            expect(car.license_plate).to eq('ABC1234')
            expect(car.color).to eq('Branco')
            expect(car.car_model_id).to eq(car_model.id)
            expect(car.mileage).to eq(200)

            expect(response).to have_http_status(:created) 
            expect(converted_json[:license_plate]).to eq(car.license_plate)
            expect(converted_json[:color]).to eq(car.color)
            expect(converted_json[:car_model_id]).to eq(car.car_model_id)
            expect(converted_json[:mileage]).to eq(car.mileage)
            expect(converted_json[:status]).to eq(car.status)
        end

        it 'should returned a client error (ActionController::ParameterMissing)' do
            #Act
            post api_v1_cars_path, params: { }

            #Assert
            converted_json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:unprocessable_entity) 
            expect(converted_json[:notice]).to eq('param is missing or the value is empty: car')
        end

        it 'should returned a client error (ActiveRecord::RecordInvalid)' do
            #Act
            post api_v1_cars_path, params: { car: { license_plate: 'ABC1234' }}

            #Assert
            converted_json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:unprocessable_entity) 
            expect(converted_json[:notice]).to eq('Validation failed: Car model must exist')
        end

        it 'should returned a server error (500)' do
            #Arrange
            manufacturer = Manufacturer.create(name: 'Fabricante1')
            car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
            car_model = CarModel.create!(name: 'Modelo1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')

            allow_any_instance_of(Car).to receive(:save!).and_raise(ActiveRecord::ConnectionNotEstablished)

            #Act
            post api_v1_cars_path, params: { car: { license_plate: 'ABC1234', color: 'Branco', car_model_id: car_model.id, mileage: '200' } }

            #Assert
            converted_json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:internal_server_error)
            expect(converted_json[:notice]).to eq('ActiveRecord::ConnectionNotEstablished')
        end
    end

    context '- update: ' do
        it 'should update a car and render a JSON with its details' do
            #Arrange
            manufacturer = Manufacturer.create(name: 'Fabricante1')
            car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
            car_model = CarModel.create!(name: 'Modelo1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')
            car = Car.create!(license_plate: 'ABC1234', color: 'Branco', car_model: car_model, mileage: '200')

            #Act
            patch api_v1_car_path(car), params: { car: { license_plate: 'ABC1234', color: 'Laranja', car_model_id: car_model.id, mileage: '200' } }

            #Assert
            converted_json = JSON.parse(response.body, symbolize_names: true)

            expect(car.reload.color).to eq('Laranja')

            expect(response).to have_http_status(:ok)
            expect(converted_json[:license_plate]).to eq(car.license_plate)
            expect(converted_json[:color]).to eq('Laranja')
            expect(converted_json[:car_model_id]).to eq(car.car_model_id)
            expect(converted_json[:mileage]).to eq(car.mileage)
        end

        it 'should returned a client error (ActionController::ParameterMissing)' do
            #Arrange
            manufacturer = Manufacturer.create(name: 'Fabricante1')
            car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
            car_model = CarModel.create!(name: 'Modelo1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')
            car = Car.create!(license_plate: 'ABC1234', color: 'Branco', car_model: car_model, mileage: '200')

            #Act
            patch api_v1_car_path(car), params: { }

            #Assert
            converted_json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:unprocessable_entity) 
            expect(converted_json[:notice]).to eq('param is missing or the value is empty: car')
        end

        it 'should returned a client error (ActiveRecord::RecordInvalid)' do
            #Arrange
            manufacturer = Manufacturer.create(name: 'Fabricante1')
            car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
            car_model = CarModel.create!(name: 'Modelo1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')
            car = Car.create!(license_plate: 'ABC1234', color: 'Branco', car_model: car_model, mileage: '200')

            #Act
            patch api_v1_car_path(car), params: { car: { car_model_id: nil } }

            #Assert
            converted_json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:unprocessable_entity) 
            expect(converted_json[:notice]).to eq('Validation failed: Car model must exist')
        end

        it 'should returned a server error (500)' do
            #Arrange
            manufacturer = Manufacturer.create(name: 'Fabricante1')
            car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
            car_model = CarModel.create!(name: 'Modelo1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')
            car = Car.create!(license_plate: 'ABC1234', color: 'Branco', car_model: car_model, mileage: '200')

            allow_any_instance_of(Car).to receive(:update!).and_raise(ActiveRecord::ConnectionNotEstablished)

            #Act
            patch api_v1_car_path(car), params: { car: { license_plate: 'ABC1234', color: 'Laranja', car_model_id: car_model.id, mileage: '200' } }

            #Assert
            converted_json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:internal_server_error)
            expect(converted_json[:notice]).to eq('ActiveRecord::ConnectionNotEstablished')
        end
    end

    context '- delete: ' do
        it 'should delete a car and render a JSON with its details' do
            #Arrange
            manufacturer = Manufacturer.create(name: 'Fabricante1')
            car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
            car_model = CarModel.create!(name: 'Modelo1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')
            car1 = Car.create!(license_plate: 'ABC1234', color: 'Branco', car_model: car_model, mileage: '200')
            car2 = Car.create!(license_plate: 'CBA1212', color: 'Branco', car_model: car_model, mileage: '200')

            #Act
            delete "/api/v1/cars/#{car2.id}"

            #Assert
            converted_json = JSON.parse(response.body, symbolize_names: true)

            expect(Car.all.length).to eq(1)
            expect(Car.last.license_plate).to eq(car1.license_plate)

            expect(response).to have_http_status(:ok)
            expect(converted_json[:notice]).to eq("Carro de placa 'CBA1212' deletado com sucesso")
        end

        it 'no car should be found' do
            #Act
            delete "/api/v1/cars/#{000}"

            #Assert
            converted_json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:not_found)
            expect(converted_json[:notice]).to eq("Couldn't find Car with 'id'=0")
        end

        it 'should returned a server error (500)' do
            #Arrange
            manufacturer = Manufacturer.create(name: 'Fabricante1')
            car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
            car_model = CarModel.create!(name: 'Modelo1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')
            car = Car.create!(license_plate: 'ABC1234', color: 'Branco', car_model: car_model, mileage: '200')

            allow_any_instance_of(Car).to receive(:destroy).and_raise(ActiveRecord::ConnectionNotEstablished)

            #Act
            delete "/api/v1/cars/#{car.id}"

            #Assert
            converted_json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:internal_server_error)
            expect(converted_json[:notice]).to eq('ActiveRecord::ConnectionNotEstablished')
        end
    end

    context '- status: ' do
        it 'must change the status of a particular car' do
            #Arrange
            manufacturer = Manufacturer.create(name: 'Fabricante1')
            car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
            car_model = CarModel.create!(name: 'Modelo1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')
            car = Car.create!(license_plate: 'ABC1234', color: 'Branco', car_model: car_model, mileage: '200', status: 'available')

            #Act
            patch status_api_v1_car_path(car), params: { status: 'unavailable' }

            #Assert
            converted_json = JSON.parse(response.body, symbolize_names: true)

            expect(car.reload.status).to eq('unavailable')

            expect(response).to have_http_status(:ok)
            expect(converted_json[:notice]).to eq("Carro de placa 'ABC1234' alterado com sucesso. Seu status agora é: 'Indisponível'")
        end

        it 'should returned a client error (ActiveRecord::RecordInvalid)' do
            #Arrange
            manufacturer = Manufacturer.create(name: 'Fabricante1')
            car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
            car_model = CarModel.create!(name: 'Modelo1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')
            car = Car.create!(license_plate: 'ABC1234', color: 'Branco', car_model: car_model, mileage: '200', status: 'available')

            #Act
            patch status_api_v1_car_path(car), params: { status: 'valor_inexistente' }

            #Assert
            converted_json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:unprocessable_entity) 
            expect(converted_json[:notice]).to eq("'valor_inexistente' is not a valid status")
        end

        it 'should returned a server error (500)' do
            #Arrange
            manufacturer = Manufacturer.create(name: 'Fabricante1')
            car_category = CarCategory.create!(name: 'Categoria1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)
            car_model = CarModel.create!(name: 'Modelo1', year: '2019', manufacturer: manufacturer, motorization: '50', car_category: car_category, fuel_type: 'Etanol')
            car = Car.create!(license_plate: 'ABC1234', color: 'Branco', car_model: car_model, mileage: '200', status: 'available')

            allow_any_instance_of(Car).to receive(:update).and_raise(ActiveRecord::ConnectionNotEstablished)

            #Act
            patch status_api_v1_car_path(car), params: { status: 'unavailable' }

            #Assert
            converted_json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:internal_server_error)
            expect(converted_json[:notice]).to eq('ActiveRecord::ConnectionNotEstablished')
        end
    end
end