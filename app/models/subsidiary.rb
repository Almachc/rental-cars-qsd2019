class Subsidiary < ApplicationRecord
    validates :cnpj, uniqueness: {message: 'Filial já existente'}, format: {with: /\d{14}/, message: 'CNPJ inválido'}
end
