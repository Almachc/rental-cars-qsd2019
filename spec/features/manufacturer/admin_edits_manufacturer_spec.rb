require 'rails_helper'

feature 'Admin edits manufacturer' do
  scenario 'successfully' do
    #Arrange
    user = create(:user)
    fabricante = create(:manufacturer, name: 'Hyundsqe')

    #Act
    login_as(user, scope: :user)
    visit root_path
    click_on 'Fabricantes'

    click_on 'Hyundsqe'

    click_on 'Editar'

    fill_in 'Nome', with: 'Hyundai'
    click_on 'Enviar'

    #Assert
    expect(fabricante.reload.name).to eq 'Hyundai'

    expect(current_path).to eq manufacturer_path(fabricante)

    expect(page).to have_content('Fabricante editada com sucesso')
    expect(page).to have_content('Hyundai')
  end

  scenario '(all fields must be filled)' do
    #Arrange
    user = create(:user)
    create(:manufacturer)

    #Act
    login_as(user, scope: :user)
    visit root_path
    click_on 'Fabricantes'
    click_on 'Hyundai'
    click_on 'Editar'

    fill_in 'Nome', with: ''
    click_on 'Enviar'

    #Assert
    expect(Manufacturer.first.name.empty?).to eq false

    expect(page).to have_field('Nome', with: '')
    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Nome deve ser preenchido')
  end

  scenario '(name must be unique)' do
    #Arrange
    user = create(:user)
    manufacturer = create(:manufacturer, name: 'Chevrolet')
    create(:manufacturer, name: 'Hyundai')

    #Act
    login_as(user, scope: :user)
    visit root_path
    click_on 'Fabricantes'
    click_on 'Chevrolet'
    click_on 'Editar'

    fill_in 'Nome', with: 'Hyundai'
    click_on 'Enviar'

    #Assert
    expect(manufacturer.reload.name).to eq 'Chevrolet'

    expect(page).to have_field('Nome', with: 'Hyundai')
    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Nome deve ser único')
  end

  scenario '(must be authenticated to have access to the edit form)' do
    #Act
    visit edit_manufacturer_path(3301)

    #Assert
    expect(current_path).to eq new_user_session_path
  end

  scenario '(must be authenticated to edit it)' do
    #Act
    page.driver.submit :patch, manufacturer_path(3301), {}

    #Assert
    expect(current_path).to eq new_user_session_path
  end
end