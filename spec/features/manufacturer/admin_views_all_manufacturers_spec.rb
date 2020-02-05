require 'rails_helper'

feature 'Admin views all manufacturers' do
  scenario 'successfully' do
    # Arrange
    user = create(:user)
    create(:manufacturer, name: 'Hyundai')
    create(:manufacturer, name: 'Chevrolet')
    create(:manufacturer, name: 'Volkswagen')

    # Act
    login_as(user, scope: :user)
    visit root_path
    click_on 'Fabricantes'

    # Assert
    expect(page).to have_content('Hyundai')
    expect(page).to have_content('Chevrolet')
    expect(page).to have_content('Volkswagen')
  end

  scenario 'and returns to home page' do
    #Arrange
    user = create(:user)

    #Act
    login_as(user, scope: :user)
    visit root_path
    click_on 'Fabricantes'

    click_on 'Voltar'

    #Assert
    expect(current_path).to eq root_path
  end

  scenario '(must be authenticated to have access from the menu)' do
    #Act
    visit root_path

    #Assert
    expect(page).to_not have_link('Fabricantes')
  end

  scenario '(must be authenticated to have access from the url)' do
    #Act
    visit manufacturers_path

    #Assert
    expect(current_path).to eq new_user_session_path
  end
end