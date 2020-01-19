class Subsidiary < ApplicationRecord
    validates :cnpj,
        uniqueness: {message: 'Filial deve ser única'},
        format: {with: /\d{14}/, message: 'CNPJ deve ser válido'}
end
