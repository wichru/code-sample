class CreateWorkOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :work_orders do |t|
      t.string :order_number
      t.datetime :starting_at
      t.datetime :ending_at
      t.text :description
      t.references :appointment, foreign_key: true

      t.timestamps
    end
  end
end
