require 'rails_helper'

feature 'Admin views all manufacturers' do
  scenario 'successfully' do
    # Arrange
    Manufacturer.create!(name: 'Fiat')
    Manufacturer.create!(name: 'Volkswagen')

    # Act
    visit root_path
    click_on 'Fabricantes'

    # Assert
    expect(page).to have_content('Fiat')
    expect(page).to have_content('Volkswagen')
  end

  scenario 'and returns to home page' do
    visit root_path
    click_on 'Fabricantes'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end
end