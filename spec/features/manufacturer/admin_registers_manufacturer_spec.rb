require 'rails_helper'

feature 'Admin registers manufacturer' do
  scenario 'successfully' do
    #Arrange
    user = create(:user)
  
    #Act
    login_as(user, scope: :user)
    visit root_path
    click_on 'Fabricantes'

    click_on 'Registrar novo fabricante'

    fill_in 'Nome', with: 'Hyundai'
    click_on 'Enviar'

    #Assert
    expect(page).to have_content('Hyundai')
    expect(page).to have_content('Fabricante criada com sucesso')
  end

  scenario '(all fields must be filled)' do
    #Arrange
    user = create(:user)

    #Act
    login_as(user, scope: :user)
    visit root_path
    click_on 'Fabricantes'

    click_on 'Registrar novo fabricante'

    click_on 'Enviar'

    #Assert
    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Nome deve ser preenchido')
  end

  scenario '(name must be unique)' do
    #Arrange
    user = create(:user)
    create(:manufacturer, name: 'Hyundai')

    #Act
    login_as(user, scope: :user)
    visit root_path
    click_on 'Fabricantes'

    click_on 'Registrar novo fabricante'

    fill_in 'Nome', with: 'Hyundai'
    click_on 'Enviar'

    #Assert
    expect(page).to have_field('Nome', with: 'Hyundai')
    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Nome deve ser único')
  end

  scenario '(must be authenticated to access the create form)' do
    #Act
    visit new_manufacturer_path

    #Assert
    expect(current_path).to eq new_user_session_path
  end

  scenario '(must be authenticated to register it)' do
    #Act
    page.driver.submit :post, manufacturers_path, {}

    #Assert
    expect(current_path).to eq new_user_session_path
  end
end