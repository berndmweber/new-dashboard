class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :puppetmaster_url
      t.string :puppetdb_url
      t.string :githubrepo_url

      t.timestamps
    end

    add_index :customers, :name, :unique => true
  end
end
