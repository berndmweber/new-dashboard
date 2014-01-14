class AddCustomerIdToPuppetmasters < ActiveRecord::Migration
  def change
    add_column :puppetmasters, :customer_id, :integer
  end
end
