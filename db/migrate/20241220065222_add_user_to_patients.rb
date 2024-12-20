class AddUserToPatients < ActiveRecord::Migration[7.2]
  def change
    add_reference :patients, :user, null: true, foreign_key: true
    
    reversible do |dir|
      dir.up do
        User.create!(
          email: 'admin@example.com',
          password: 'password123',
          first_name: 'Admin',
          last_name: 'User'
        ) if Patient.any? && User.none?

        if (user = User.first) && Patient.where(user_id: nil).any?
          Patient.where(user_id: nil).update_all(user_id: user.id)
        end

        change_column_null :patients, :user_id, false
      end
    end
  end
end