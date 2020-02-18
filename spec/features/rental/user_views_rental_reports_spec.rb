require 'rails_helper'

feature 'User views rental reports' do
    scenario 'successfully' do
        #Arrange
        user = create(:user)
        client = create(:client)

        manufacturer = create(:manufacturer)
        subsidiary = create(:subsidiary)

        car_categoryA = create(:car_category, name: 'catA')
        car_categoryB = create(:car_category, name: 'catB')
        car_categoryC = create(:car_category, name: 'catC')

        car_model1 = create(:car_model, name: 'HB20', car_category: car_categoryA, manufacturer: manufacturer)
        car_model2 = create(:car_model, name: 'Azera', car_category: car_categoryB, manufacturer: manufacturer)
        car_model3 = create(:car_model, name: 'Creta', car_category: car_categoryC, manufacturer: manufacturer)
        car_model4 = create(:car_model, name: 'Credilds', car_category: car_categoryC, manufacturer: manufacturer)

        car1 = create(:car, license_plate: 'ABC1234', car_model: car_model1, subsidiary: subsidiary)
        car2 = create(:car, license_plate: 'CAB2345', car_model: car_model2, subsidiary: subsidiary)
        car3 = create(:car, license_plate: 'BCA3456', car_model: car_model3, subsidiary: subsidiary)
        car4 = create(:car, license_plate: 'RRR4567', car_model: car_model4, subsidiary: subsidiary)

        rental1 = create(:rental, code: 'CIC3301', client: client, car_category: car1.car_model.car_category, user: user, status: 'effective')
        rental2 = create(:rental, code: 'CIC3302', client: client, car_category: car2.car_model.car_category, user: user, status: 'effective')
        rental3 = create(:rental, code: 'CIC3303', client: client, car_category: car3.car_model.car_category, user: user, status: 'effective')
        rental4 = create(:rental, code: 'CIC3304', client: client, car_category: car4.car_model.car_category, user: user, status: 'effective')
        rental5 = create(:rental, code: 'CIC3305', client: client, car_category: car1.car_model.car_category, user: user, status: 'effective')

        car_rental1 = create(:car_rental, rental: rental1, car: car1)
        car_rental2 = create(:car_rental, rental: rental2, car: car2)
        car_rental3 = create(:car_rental, rental: rental3, car: car3)
        car_rental4 = create(:car_rental, rental: rental4, car: car4)
        car_rental5 = create(:car_rental, rental: rental5, car: car1)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Locações'

        click_on 'Gerar relatório'

        select 'Categoria', from: 'Filtrar locações por:'
        fill_in 'Período inicial', with: '02-02-2020'
        fill_in 'Período final', with: I18n.l(1.day.from_now, format: I18n.t('date.formats.default'))
        
        click_on 'Buscar'

        #Assert
        expect(current_path).to eq report_rentals_path
        expect(page).to have_content("Período: 02-02-2020 até #{I18n.l(1.day.from_now, format: I18n.t('date.formats.default'))}")
        expect(page).to have_content('Relatório 01')
        expect(page).to have_content('catA = 2')
        expect(page).to have_content('catB = 1')
        expect(page).to have_content('catA = 2')
        expect(page).to have_content('Relatório 02')
        expect(page).to have_content('HB20 = 2')
        expect(page).to have_content('Azera = 1')
        expect(page).to have_content('Creta = 1')
        expect(page).to have_content('Credilds = 1')
    end
end