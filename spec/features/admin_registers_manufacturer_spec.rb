require 'rails_helper'

feature 'Admin registers manufacturer' do
  scenario 'successfully' do
    #Act
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
    #Act
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
    Manufacturer.create!(name: 'Honda')

    #Act
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
end