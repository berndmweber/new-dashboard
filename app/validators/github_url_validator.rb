require 'uri'

class GithubUrlValidator < ActiveModel::EachValidator
  include Admin::UtilsHelper

  def validate_each(record, attribute, value)
  	uri = URI(value)
    unless uri.scheme == 'https'
      record.errors[attribute] << (options[:message] || "needs to have a https scheme")
    end
    unless uri.host == 'github.com'
      record.errors[attribute] << (options[:message] || "needs to have a host of github.com")
    end
    unless uri.path =~ /\.git$/
      record.errors[attribute] << (options[:message] || "needs to be a git repository path (ending with .git)")
    end
  end
end