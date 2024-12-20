class Patient < ApplicationRecord
	paginates_per 10
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, 
                   email_format: true, 
                   uniqueness: { case_sensitive: false }

  scope :upcoming_appointments, -> { 
    where('next_appointment_date <= ? AND next_appointment_date >= ?', 
          72.hours.from_now, 
          Time.current)
  }

  scope :search, ->(query) {
    where('lower(first_name) LIKE :query OR lower(last_name) LIKE :query OR lower(email) LIKE :query',
          query: "%#{query.downcase}%")
  }

  def full_name
    "#{first_name} #{last_name}"
  end
end