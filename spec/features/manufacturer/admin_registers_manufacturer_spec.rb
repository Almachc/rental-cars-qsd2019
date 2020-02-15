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
    expect(Manufacturer.count).to eq 1
    manufacturer = Manufacturer.first
    expect(manufacturer.name).to eq 'Hyundai'

    expect(current_path).to eq manufacturer_path(manufacturer)

    expect(page).to have_content('Hyundai')
    expect(page).to have_content('Fabricante registrada com sucesso')
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
    expect(Manufacturer.count).to eq 0

    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Nome não pode ficar em branco')
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
    expect(Manufacturer.count).to eq 1

    expect(page).to have_field('Nome', with: 'Hyundai')
    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Nome já está em uso')
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