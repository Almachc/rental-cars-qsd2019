require 'rails_helper'

describe 'Rentals management' do
    context '- index: must render a json with all rentals for a given client' do
        it '(successfully)' do
            #Arrange
            user = create(:user)
            client1 = create(:client, name: 'Leopoldo', cpf: 42072026838, email: 'leopoldo@gmail.com')
            client2 = create(:client, name: 'Leopoldina', cpf: 42072026555, email: 'leopoldina@gmail.com')
            car_category = create(:car_category)
            rental1 = create(:rental, code: 'CIC3333', client: client1, car_category: car_category, user: user, status: 'effective')
            rental2 = create(:rental, code: 'CIC4444', client: client1, car_category: car_category, user: user, status: 'canceled')
            create(:rental, code: 'CIC5555', client: client2, car_category: car_category, user: user, status: 'effective')
            
            #Act
            get api_v1_rentals_path, params: {client: {cpf: 42072026838}}

            #Assert
            converted_json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:ok) 
            expect(converted_json[0][:code]).to eq(rental1.code)
            expect(converted_json[0][:client_id]).to eq(client1.id)
            expect(converted_json[1][:code]).to eq(rental2.code)
            expect(converted_json[1][:client_id]).to eq(client1.id)
        end

        it '(no rental should be found)' do
            #Act
            get api_v1_rentals_path, params: {client: {cpf: 42072026838}}

            #Assert
            converted_json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:not_found) 
            expect(converted_json[:notice]).to eq('Nenhum resultado encontrado')
        end
    end
    
    context '- show: must render a json with the details of a rental' do
        it '(successfully)' do
            #Arrange
            user = create(:user)
            client = create(:client)
            car_category = create(:car_category)
            rental = create(:rental, client: client, car_category: car_category, user: user)
           
            #Act
            get api_v1_rental_path(rental)

            #Assert
            converted_json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:ok) 
            expect(converted_json[:code]).to eq(rental.code)
            expect(converted_json[:car_category_id]).to eq(rental.car_category.id)
            expect(converted_json[:status]).to eq(rental.status)
        end

        it '(no rental should be found)' do
            #Act
            get api_v1_rental_path(0)

            #Assert
            converted_json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:not_found) 
            expect(converted_json[:notice]).to eq('Nenhum resultado encontrado')
        end
    end
end