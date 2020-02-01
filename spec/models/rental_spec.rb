require 'rails_helper'

describe Rental do
    describe '- property start_date: ' do
        it 'cannot be in the past' do
            #Arrange
            rental = Rental.new(start_date: 1.day.ago, end_date: Date.current)

            #Act
            rental.valid?

            #Assert
            expect(rental.errors.messages[:start_date]).to include('Data inicial não deve estar no passado')
        end
    
        it 'cannot be empty' do
            #Arrange
            rental = Rental.new(start_date: nil, end_date: Date.current)

            #Act
            rental.valid?

            #Assert
            expect(rental.errors.messages[:start_date]).to include('Data inicial deve ser preenchida')
        end
    end

    describe '- property end_date: ' do
        it 'must be greater than start date' do
            #Arrange
            rental = Rental.new(start_date: Date.current, end_date: 1.day.ago)

            #Act
            rental.valid?
        
            #Assert
            expect(rental.errors.messages[:end_date]).to include('Data final deve ser maior que a data inicial')
        end

        it 'cannot be empty' do
            #Arrange
            rental = Rental.new(start_date: Date.current, end_date: nil)

            #Act
            rental.valid?

            #Assert
            expect(rental.errors.messages[:end_date]).to include('Data final deve ser preenchida')
        end
    end

    describe '- method cancel: ' do
        it 'description must be filled' do
            #Arrange
            rental = Rental.new(start_date: 2.days.from_now, end_date: 5.days.from_now, status: 'pending')

            #Act
            rental.cancel(description: '')
            
            #Assert
            expect(rental.errors.messages[:cancel]).to include('A descrição deve ser preenchida')
        end

        it 'rental must be pending to be canceled' do
            #Arrange
            rental = Rental.new(start_date: 2.days.from_now, end_date: 5.days.from_now, status: 'effective')
    
            #Act
            rental.cancel(description: 'Alguma descrição...')
    
            #Assert
            expect(rental.errors.messages[:cancel]).to include('A locação deve estar pendente para ser cancelada')
        end

        it 'cancellation must be made at least 24 hours before the start date' do
            #Arrange
            rental = Rental.new(start_date: 23.hours.from_now, end_date: 5.days.from_now, status: 'pending')
    
            #Act
            rental.cancel(description: 'Alguma descrição...')
    
            #Assert
            expect(rental.errors.messages[:cancel]).to include('A locação já excedeu o tempo limite de cancelamento')
        end
    end
end