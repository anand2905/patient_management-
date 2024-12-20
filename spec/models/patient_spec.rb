require 'rails_helper'

RSpec.describe Patient, type: :model do
  describe 'validations' do
    let(:patient) { build(:patient) }

    it 'is valid with valid attributes' do
      expect(patient).to be_valid
    end

    it 'is not valid without a first_name' do
      patient.first_name = nil
      expect(patient).to_not be_valid
      expect(patient.errors[:first_name]).to include("can't be blank")
    end

    it 'is not valid without a last_name' do
      patient.last_name = nil
      expect(patient).to_not be_valid
      expect(patient.errors[:last_name]).to include("can't be blank")
    end

    it 'is not valid without an email' do
      patient.email = nil
      expect(patient).to_not be_valid
      expect(patient.errors[:email]).to include("can't be blank")
    end

    it 'is not valid with an invalid email format' do
      patient.email = 'invalid_email'
      expect(patient).to_not be_valid
      expect(patient.errors[:email]).to include("does not appear to be a valid email address")
    end

    it 'is not valid with a non-unique email (case insensitive)' do
      create(:patient, email: 'test@example.com')
      patient.email = 'TEST@example.com'
      expect(patient).to_not be_valid
      expect(patient.errors[:email]).to include('has already been taken')
    end
  end

  describe 'scopes' do
    describe '.upcoming_appointments' do
      let!(:patient1) { create(:patient, next_appointment_date: 48.hours.from_now) }
      let!(:patient2) { create(:patient, next_appointment_date: 1.hour.from_now) }
      let!(:patient3) { create(:patient, next_appointment_date: 80.hours.from_now) }
      let!(:patient4) { create(:patient, next_appointment_date: nil) }

      it 'includes patients with appointments within the next 72 hours' do
        expect(Patient.upcoming_appointments).to contain_exactly(patient1, patient2)
      end

      it 'excludes patients with appointments outside the 72-hour window or without appointments' do
        expect(Patient.upcoming_appointments).not_to include(patient3, patient4)
      end
    end

    describe '.search' do
      let!(:patient1) { create(:patient, first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com') }
      let!(:patient2) { create(:patient, first_name: 'Jane', last_name: 'Smith', email: 'jane.smith@example.com') }

      it 'finds patients by first name' do
        expect(Patient.search('john')).to include(patient1)
      end

      it 'finds patients by last name' do
        expect(Patient.search('doe')).to include(patient1)
      end

      it 'finds patients by email' do
        expect(Patient.search('jane.smith@example.com')).to include(patient2)
      end

      it 'is case insensitive' do
        expect(Patient.search('JOHN')).to include(patient1)
      end

      it 'does not include patients that do not match the query' do
        expect(Patient.search('nonexistent')).to be_empty
      end
    end
  end

  describe '#full_name' do
    let(:patient) { build(:patient, first_name: 'John', last_name: 'Doe') }

    it 'returns the full name of the patient' do
      expect(patient.full_name).to eq('John Doe')
    end
  end

  describe 'pagination' do
    before do
      create_list(:patient, 15)
    end

    it 'paginates the results to the specified per-page limit' do
      expect(Patient.page(1).per(10).size).to eq(10)
      expect(Patient.page(2).per(10).size).to eq(5)
    end
  end
end
