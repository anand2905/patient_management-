# Patient Management System

A Ruby on Rails application for managing patient records and appointments.

## Prerequisites

- Ruby 3.3.4
- Rails 8.0.1
- Postgres

## Setup

1. Clone the repository (git clone https://github.com/anand2905/patient_management-.git)
2. Install dependencies:
```bash
bundle install
```

3. Set up the database:
```bash
rails db:create
rails db:migrate
```

4. (Optional) Seed the database with sample data:
```bash
rails db:seed
```

5. Run the test suite:
```bash
rspec
```

6. Start the server:
```bash
rails server
```

The application will be available at `http://localhost:3000`

6. Default Admin creds:
```bash
 email: 'admin@example.com',
 password: 'password123',
```

## Features

- View all patients with pagination (10 patients per page)
- Search patients by name or email
- View patients with upcoming appointments (within 72 hours)
- Create new patients
- Edit existing patient information
- Email uniqueness validation
- Comprehensive test coverage

## Technical Details

- Uses Kaminari for pagination
- Uses validates_email_format_of for email validation
- Includes RSpec tests with FactoryBot and Faker
