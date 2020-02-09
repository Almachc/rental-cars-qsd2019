require 'rails_helper'

feature 'Admin registers car accessory' do
	scenario 'successfully' do
		#Arrange
		user = create(:user)
		car_model = create(:car_model)

		#Act
		login_as(user, scope: :user)
		visit root_path
		click_on 'Acessórios de carro'

		click_on 'Registrar novo acessório'

		fill_in 'Nome', with: 'GPS'
		fill_in 'Descrição', with: 'Blablabla'
		fill_in 'Diária', with: '100'
		attach_file 'car_accessory_photo', 'spec/files/images/gps.jpg'
		click_on 'Enviar'

		#Assert
		expect(CarAccessory.count).to eq 1
		car_accessory = CarAccessory.first
		expect(car_accessory).to have_attributes(name: 'GPS', description: 'Blablabla',
												 daily_rate: 100)
		expect(car_accessory.photo.attached?).to eq true
		
		expect(current_path).to eq car_accessory_path(car_accessory)

		expect(page).to have_content('Acessório registrado com sucesso')
		expect(page).to have_css("img[src*='gps.jpg']")
		expect(page).to have_content('GPS')
		expect(page).to have_content('Blablabla')
		expect(page).to have_content('100')
	end
end