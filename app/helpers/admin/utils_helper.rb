require 'webrick/ssl'

module Admin::UtilsHelper
  def create_cert_key (certname, certdomain, certcomment)
  	return WEBrick::Utils::create_self_signed_cert(2048, [['CN', certname], ['DC', certdomain]], certcomment)
  end

  def save_data_to_file (filename, data)
    begin
      file = File.open(filename, "w")
      file.write (data)
    rescue IOError => e
      logger.debug "Error: #{e}"
    ensure
      file.close unless file == nil
    end
  end
end
