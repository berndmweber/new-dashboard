class AddSslCsrToPuppetmasters < ActiveRecord::Migration
  def change
    add_column :puppetmasters, :sslCsr, :string
  end
end
