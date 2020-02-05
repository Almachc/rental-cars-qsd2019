FactoryBot.define do
	factory :user do
		email { "user@gmail.com" }
		password { "123456" }
	end

	factory :client do
		name { "Leopoldo" }
		cpf { "42074026838" }
		email { "leopoldo@gmail.com" }
	end

	factory :subsidiary do
		name { "Filial1" }
		cnpj { "10.394.422/0001-42" }
		address { "Av Sei La, 203" }
	end

	factory :manufacturer do
		name { "Hyundai" }
	end

	factory :car_category do
		name { "catA" }
		daily_rate { 200.55 }
		car_insurance { 1000.55 }
		third_party_insurance { 1500.55 }
	end

	factory :car_model do
		name { "HB20" }
		year { "2019" }
		motorization { "1.6" }
		fuel_type { "Gasolina" }
		manufacturer
		car_category
	end

	factory :car do
		license_plate { "BAR2030" }
		color { "Chumbo" }
		mileage { 7000 }
		status { 0 }
	  car_model 
	end

	factory :rental do
		code { "CIC3301" }
		start_date { Date.current }
		end_date { 5.days.from_now }
		status { 0 }
		description { "" }
	  	client
		car_category
		user
	end

	factory :car_rental do
		price { 2500.50 }
		start_mileage { 5000 }
		end_mileage { 5500 }
		rental
		car
	end
end