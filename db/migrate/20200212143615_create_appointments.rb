class CreateAppointments < ActiveRecord::Migration[5.1]
  def change
    create_table :appointments do |t|
      t.boolean :customer_waiting

      t.timestamps
    end
  end
end
