class OrdersUuidAsString < ActiveRecord::Migration[5.2]
  def self.up
    drop_table :orders
    create_table :orders, id: :string do |t|
      t.string :currency
      t.decimal :amount
      t.decimal :purchase_price
      t.decimal :investment
      t.string :user_uuid

      t.timestamps
    end
    
    add_index(:orders, :user_uuid, unique: false)
  end
  
  def self.down
    drop_table :orders
    create_table :orders, id: :uuid do |t|
      t.string :currency
      t.decimal :amount
      t.decimal :purchase_price
      t.decimal :investment

      t.timestamps
    end
  end
end
