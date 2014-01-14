class RemovePuppetmasterUrlFromCustomers < ActiveRecord::Migration
  def up
    remove_column :customers, :puppetmaster_url
  end

  def down
    add_column :customers, :puppetmaster_url, :string
  end
end
