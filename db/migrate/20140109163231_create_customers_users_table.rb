class CreateCustomersUsersTable < ActiveRecord::Migration
  def up
    create_table :customers_users, :id => false do |t|
      t.references :customer, :user
    end
  end

  def down
  	drop_table :customers_users
  end
end
