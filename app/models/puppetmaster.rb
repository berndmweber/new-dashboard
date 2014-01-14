class Puppetmaster < ActiveRecord::Base
  include ActiveModel::Validations

  belongs_to :customer

  attr_accessible :port, :sslCert, :sslKey, :url, :customer_id

  validates :url, :customer_id, presence: true
  validates :url, format: { with: /^https:\/\/([\da-z\.-]+)\.([a-z\.]{2,6})/,
    message: "only allows https and valid domain names" }

  validates :port, numericality: { :greater_than => 0 }
  validates :port, numericality: { :less_than_or_equal_to => 65535 }

  validates :sslCert, presence: true, file: true

  validates :sslKey, presence: true, file: true
end
