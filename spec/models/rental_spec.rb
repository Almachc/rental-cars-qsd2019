require 'rails_helper'

describe Rental do
    describe '- property start_date: ' do
        it 'cannot be in the past' do
            #Arrange
            rental = Rental.new(start_date: 1.day.ago, end_date: Date.current)

            #Act
            rental.valid?

            #Assert
            expect(rental.errors.full_messages).to include('Data inicial não deve estar no passado')
        end
    
        it 'cannot be empty' do
            #Arrange
            rental = Rental.new(start_date: nil, end_date: Date.current)

            #Act
            rental.valid?

            #Assert
            expect(rental.errors.full_messages).to include('Data inicial não pode ficar em branco')
        end
    end

    describe '- property end_date: ' do
        it 'must be greater than start date' do
            #Arrange
            rental = Rental.new(start_date: Date.current, end_date: 1.day.ago)

            #Act
            rental.valid?
        
            #Assert
            expect(rental.errors.full_messages).to include('Data final deve ser maior que Data inicial')
        end

        it 'cannot be empty' do
            #Arrange
            rental = Rental.new(start_date: Date.current, end_date: nil)

            #Act
            rental.valid?

            #Assert
            expect(rental.errors.full_messages).to include('Data final não pode ficar em branco')
        end
    end

    describe '- method cancel: ' do
        it 'description must be filled' do
            #Arrange
            rental = Rental.new(start_date: 2.days.from_now, end_date: 5.days.from_now, status: 'pending')

            #Act
            rental.cancel(description: '')
            
            #Assert
            expect(rental.errors.full_messages).to include('Descrição não pode ficar em branco')
        end

        it 'rental must be pending to be canceled' do
            #Arrange
            rental = Rental.new(start_date: 2.days.from_now, end_date: 5.days.from_now, status: 'effective')
    
            #Act
            rental.cancel(description: 'Alguma descrição...')
    
            #Assert
            expect(rental.errors.full_messages).to include("Status deve ser 'pendente'")
        end

        it 'cancellation must be made at least 24 hours before the start date' do
            #Arrange
            rental = Rental.new(start_date: 23.hours.from_now, end_date: 5.days.from_now, status: 'pending')
    
            #Act
            rental.cancel(description: 'Alguma descrição...')
    
            #Assert
            expect(rental.errors.full_messages).to include('A locação já excedeu o tempo limite de cancelamento (24h)')
        end
    end
end