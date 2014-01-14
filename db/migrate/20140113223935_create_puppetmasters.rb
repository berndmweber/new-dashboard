class CreatePuppetmasters < ActiveRecord::Migration
  def change
    create_table :puppetmasters do |t|
      t.string :url
      t.string :port
      t.string :sslCert
      t.string :sslKey

      t.timestamps
    end
  end
end
