require 'rails_helper'

feature 'Admin edits manufacturer' do
  scenario 'successfully' do
    Manufacturer.create(name: 'Fiat')

    visit root_path
    click_on 'Fabricantes'
    click_on 'Fiat'
    click_on 'Editar'
    fill_in 'Nome', with: 'Honda'
    click_on 'Enviar'

    expect(page).to have_content('Honda')
  end

  scenario 'and must fill in all fields' do
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
    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Nome não pode ficar em branco')
  end

  scenario 'name must be unique' do
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
    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Nome deve ser único')
  end
end