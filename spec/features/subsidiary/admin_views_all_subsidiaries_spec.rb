require 'rails_helper'

feature 'Admin views all subsidiaries' do
    scenario 'successfully' do
        #Arrange
        user = create(:user)
        create(:subsidiary, name: 'Filial1', cnpj: '01234567891011')
        create(:subsidiary, name: 'Filial2', cnpj: '01234567891012')

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Filiais'
        
        #Assert
        expect(page).to have_content('Filial1')
        expect(page).to have_content('Filial2')
      
        expect(page).to have_link('Voltar')
    end

    scenario 'and returns to home page' do
        #Arrange
        user = create(:user)

        #Act
        login_as(user, scope: :user)
        visit root_path
        click_on 'Filiais'

        click_on 'Voltar'
    
        #Assert
        expect(current_path).to eq root_path
    end

    scenario '(must be authenticated to have access from the menu)' do
        #Act
        visit root_path

        #Assert
        expect(page).to_not have_link('Filiais')
    end

    scenario '(must be authenticated to have access from the url)' do
        #Act
        visit subsidiaries_path

        #Assert
        expect(current_path).to eq new_user_session_path
    end
end