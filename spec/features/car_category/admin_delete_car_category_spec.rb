require 'rails_helper'

feature 'Admin delete car category' do
    scenario 'successfully' do
        #Arrange
        user = create(:user)
        create(:car_category)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Categorias de carro'
        click_on 'catA'
        click_on 'Deletar'

        #Assert
        expect(current_path).to eq car_categories_path
        expect(page).to have_content('Categoria deletada com sucesso')
        expect(page).to have_no_content('catA')
    end

    scenario '(must be authenticated)' do
        #Act
        page.driver.submit :delete, car_category_path(3301), {}

        #Assert
        expect(current_path).to eq new_user_session_path
    end
end