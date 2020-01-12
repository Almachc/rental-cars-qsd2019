class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "Email deve ser válido")
    end
  end
end

class Client < ApplicationRecord
    validates :name, presence: { message: 'Nome deve ser preenchido' }
    
    validates :cpf, 
        presence: { message: 'CPF deve ser preenchido' },
        format: { with: /\d{11}/, message: 'CPF deve ser válido' },
        uniqueness: { message: 'CPF deve ser único' }

    validates :email, 
        presence: { message: 'Email deve ser preenchido' },
        uniqueness: { message: 'Email deve ser único' },
        email: true
end