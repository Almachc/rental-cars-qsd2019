require 'rails_helper'

feature 'Admin registers manufacturer' do
  scenario 'successfully' do
    #Arrange
    user = User.create!(email: 'teste@teste.com', password: '123456')
  
    #Act
    login_as(user, scope: :user)
    visit root_path
    click_on 'Fabricantes'

    click_on 'Registrar novo fabricante'

    fill_in 'Nome', with: 'Fiat'
    click_on 'Enviar'

    #Assert
    expect(page).to have_content('Fiat')
    expect(page).to have_content('Fabricante criada com sucesso')
  end

  scenario '(all fields must be filled)' do
    #Arrange
    user = User.create!(email: 'teste@teste.com', password: '123456')

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
    user = User.create!(email: 'teste@teste.com', password: '123456')
    Manufacturer.create!(name: 'Honda')

    #Act
    login_as(user, scope: :user)
    visit root_path
    click_on 'Fabricantes'

    click_on 'Registrar novo fabricante'

    fill_in 'Nome', with: 'Honda'
    click_on 'Enviar'

    #Assert
    expect(page).to have_field('Nome', with: 'Honda')
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