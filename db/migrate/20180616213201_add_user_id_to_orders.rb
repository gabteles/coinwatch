class AddUserIdToOrders < ActiveRecord::Migration[5.2]
  def change
    change_table :orders do |t|
      t.string :user_uuid
    end
    
    add_index(:orders, :user_uuid, unique: false)
  end
end
