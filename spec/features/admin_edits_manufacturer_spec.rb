require 'rails_helper'

feature 'Admin edits manufacturer' do
  scenario 'successfully' do
    #Arrange
    fabricante = Manufacturer.create(name: 'Fiat')

    #Act
    visit root_path
    click_on 'Fabricantes'

    click_on 'Fiat'

    click_on 'Editar'

    fill_in 'Nome', with: 'Honda'
    click_on 'Enviar'

    #Assert
    expect(current_path).to eq manufacturer_path(fabricante)
    expect(page).to have_content('Fabricante editada com sucesso')
    expect(page).to have_content('Honda')
  end

  scenario '(all fields must be filled)' do
    #Arrange
    Manufacturer.create(name: 'Fiat')

    #Act
    visit root_path
    click_on 'Fabricantes'
    click_on 'Fiat'
    click_on 'Editar'

    fill_in 'Nome', with: ''
    click_on 'Enviar'

    #Assert
    expect(page).to have_field('Nome', with: '')
    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Nome deve ser preenchido')
  end

  scenario '(name must be unique)' do
    #Arrange
    Manufacturer.create(name: 'Fiat')
    Manufacturer.create(name: 'Hyundai')

    #Act
    visit root_path
    click_on 'Fabricantes'
    click_on 'Fiat'
    click_on 'Editar'

    fill_in 'Nome', with: 'Hyundai'
    click_on 'Enviar'

    #Assert
    expect(page).to have_field('Nome', with: 'Hyundai')
    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Nome deve ser único')
  end
end