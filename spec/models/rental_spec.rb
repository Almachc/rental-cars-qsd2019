require 'rails_helper'

xdescribe Rental do
    describe '- The property start_date' do
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
            expect(rental.errors.full_messages).to include('Data deve ser preenchida')
        end
    end

    describe '- The property end_date' do
        it 'must be greater than start date' do
            #Arrange
            rental = Rental.new(start_date: 1.day.ago, end_date: Date.current)

            #Act
            rental.valid?
        
            #Assert
            expect(rental.errors.full_messages).to include('Data inicial não deve estar no passado')
        end

        it 'cannot be empty' do
            #Arrange
            rental = Rental.new(start_date: Date.current, end_date: nil)

            #Act
            rental.valid?

             #Assert
            expect(rental.errors.full_messages).to include('Data final deve ser preenchida')
        end
    end
end