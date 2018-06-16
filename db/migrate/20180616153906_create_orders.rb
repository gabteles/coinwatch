class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders, id: :uuid do |t|
      t.string :currency
      t.decimal :amount
      t.integer :purchase_price

      t.timestamps
    end
  end
end
