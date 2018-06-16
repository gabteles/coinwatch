class CreateCurrencies < ActiveRecord::Migration[5.2]
  def change
    create_table :currencies, id: :uuid do |t|
      t.string :symbol
      t.decimal :value_in_usd

      t.timestamps
    end
  end
end
