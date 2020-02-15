class Client < ApplicationRecord
    validates :name, presence: true
    
    validates :cpf, presence: true, uniqueness: true,
                    format: { with: /\d{11}/ }

    validates :email, presence: true, uniqueness: true,
                      format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
end