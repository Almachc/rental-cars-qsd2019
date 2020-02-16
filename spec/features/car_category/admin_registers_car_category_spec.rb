require 'rails_helper'

feature 'Admin registers car category' do
    scenario 'successfully' do
        #Arrange
        user = create(:user)
        
        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on t_model(:car_categories)

        click_on t_link(:register_new, :car_category)

        fill_in t_attribute(:name, :car_category), with: 'catA'
        fill_in t_attribute(:daily_rate, :car_category), with: '400.99'
        fill_in t_attribute(:car_insurance, :car_category), with: '700.99'
        fill_in t_attribute(:third_party_insurance, :car_category), with: '800.99'
        click_on t_link(:submit)

        #Assert
        expect(CarCategory.count).to eq 1
        car_category = CarCategory.first
        expect(CarCategory.first).to have_attributes(name: 'catA', daily_rate: 400.99,
                                                     car_insurance: 700.99,
                                                     third_party_insurance: 800.99)

        expect(current_path).to eq(car_category_path(car_category))

        expect(page).to have_content(I18n.t('car_categories.create.success'))
        expect(page).to have_content('catA')
        expect(page).to have_content('400.99')
        expect(page).to have_content('700.99')
        expect(page).to have_content('800.99')
    end

    scenario '(all fields must be filled)' do
        #Arrange
        user = create(:user)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on t_model(:car_categories)
        
        click_on t_link(:register_new, :car_category)

        click_on t_link(:submit)

        #Assert
        expect(CarCategory.count).to eq 0

        expect(page).to have_content(t_error(:name, :car_category, :blank))
        expect(page).to have_content(t_error(:daily_rate, :car_category, :blank))
        expect(page).to have_content(t_error(:car_insurance, :car_category, :blank))
        expect(page).to have_content(t_error(:third_party_insurance, :car_category, :blank))
    end

    scenario '(daily Rate, car insurance and third party insurance must be greater than zero)' do
        #Arrange
        user = create(:user)
        
        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on t_model(:car_categories)

        click_on t_link(:register_new, :car_category)

        fill_in t_attribute(:name, :car_category), with: 'catA'
        fill_in t_attribute(:daily_rate, :car_category), with: '0'
        fill_in t_attribute(:car_insurance, :car_category), with: '0'
        fill_in t_attribute(:third_party_insurance, :car_category), with: '0'
        click_on t_link(:submit)

        #Assert
        expect(CarCategory.count).to eq 0

        expect(page).to have_field(t_attribute(:name, :car_category), with: 'catA')
        expect(page).to have_field(t_attribute(:daily_rate, :car_category), with: '0')
        expect(page).to have_field(t_attribute(:car_insurance, :car_category), with: '0')
        expect(page).to have_field(t_attribute(:third_party_insurance, :car_category), with: '0')

        expect(page).to have_content(t_error(:daily_rate, :car_category, :greater_than, 0))
        expect(page).to have_content(t_error(:car_insurance, :car_category, :greater_than, 0))
        expect(page).to have_content(t_error(:third_party_insurance, :car_category, :greater_than, 0))
    end

    scenario '(must be authenticated to have access to the create form)' do
        #Act
        visit new_car_category_path

        #Assert
        expect(current_path).to eq new_user_session_path
    end

    scenario '(must be authenticated to create it)' do
        #Act
        page.driver.submit :post, car_categories_path, {}
        
        #Assert
        expect(current_path).to eq new_user_session_path
    end
end