class CreateCars < ActiveRecord::Migration[5.1]
  def change
    create_table :cars do |t|
      t.string :registration_number
      t.text :info
      t.references :appointment

      t.timestamps
    end
  end
end
