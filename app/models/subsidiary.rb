class Subsidiary < ApplicationRecord
    validates :cnpj,
        uniqueness: true,
        format: { with: /\d{14}/ }
end
