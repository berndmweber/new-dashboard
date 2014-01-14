class Customer < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :puppetmasters

  attr_accessible :githubrepo_url, :name, :puppetdb_url, :user_ids

  validates :name, presence: true

  validates :githubrepo_url, github_url: true
end
