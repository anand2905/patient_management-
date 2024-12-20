class CreatePatients < ActiveRecord::Migration[7.2]
  def change
    create_table :patients do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.datetime :next_appointment_date

      t.timestamps
    end
    add_index :patients, :email, unique: true
  end
end
