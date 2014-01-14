class FileValidator < ActiveModel::EachValidator
  include Admin::UtilsHelper

  def validate_each(record, attribute, value)
    unless file_exists(value)
      record.errors[attribute] << (options[:message] || "does not exist")
    end
  end
end