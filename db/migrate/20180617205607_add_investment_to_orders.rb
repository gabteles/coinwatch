class AddInvestmentToOrders < ActiveRecord::Migration[5.2]
  def self.up
    change_table :orders do |t|
      t.decimal :investment
    end
    
    change_column :orders, :purchase_price, :decimal

    Order.in_batches.each_record do |order|
      order.update(investment: order.amount * order.purchase_price)
    end
  end

  def self.down
    change_column :orders, :purchase_price, :integer
    remove_column :orders, :investment
  end
end
