require 'rails_helper'

feature 'Admin delete car category' do
    scenario 'successfully' do
        #Arrange
        user = User.create!(email: 'teste@teste.com', password: '123456')
        CarCategory.create!(name: 'T1', daily_rate: 1.2, car_insurance: 1.3, third_party_insurance: 1.4)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Categorias de carro'
        click_on 'T1'
        click_on 'Deletar'

        #Assert
        expect(current_path).to eq car_categories_path
        expect(page).to have_content('Categoria deletada com sucesso')
        expect(page).to have_no_content('T1')
    end

    scenario '(must be authenticated)' do
        #Act
        page.driver.submit :delete, car_category_path(3301), {}

        #Assert
        expect(current_path).to eq new_user_session_path
    end
end