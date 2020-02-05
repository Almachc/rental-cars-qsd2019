require 'rails_helper'

feature 'User cancels rental' do
    scenario 'succesfully' do
        #Arrange
        user = create(:user)
        rental = create(:rental, user: user)
        
        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Locações'

        fill_in 'Pesquisar', with: 'cic'
        click_on 'Buscar'

        within("tr#rental-#{rental.id}") do
            click_on 'Visualizar'
        end
      
        click_on 'Cancelar locação'

        within("div#cancel-rental") do
            fill_in 'Descrição', with: 'Cliente está com coronavírus'
            click_on 'Confirmar'
        end

        #Assert
        expect(page).to have_content('Locação cancelada com sucesso')

        expect(rental.reload.description).to eq('Cliente está com coronavírus')
        expect(rental.reload.status).to eq('canceled')
    end

    scenario '(rental must be pending for the cancellation button to be displayed)' do
        #Arrange
        user = create(:user)
        rental = create(:rental, user: user, status: 'canceled')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Locações'

        fill_in 'Pesquisar', with: 'cic3301'
        click_on 'Buscar'

        #Assert
        expect(page).to_not have_content('Cancelar locação')
    end

    scenario '(must be authenticated to cancel by url)' do
        #Act
        page.driver.submit :patch, cancel_rental_path(000), {}

        #Assert
        expect(current_path).to eq new_user_session_path
    end
end