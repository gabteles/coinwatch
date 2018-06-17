class UpdateCurrencies < ActiveRecord::Migration[5.2]
  def self.up
    drop_table :currencies
    create_table :currencies, id: false do |t|
      t.string :symbol, primary_key: true, null: false
      t.decimal :value_in_usd
      t.timestamps
    end
  end
  
  def self.down
    drop_table :currencies
    create_table :currencies, id: :uuid do |t|
      t.string :symbol
      t.decimal :value_in_usd
      
      t.timestamps
    end
  end
end
