require 'openssl'
require "net/https"
require "uri"

module Admin::UtilsHelper
  def create_cert_key (certname, certdomain)
  	# return WEBrick::Utils::create_self_signed_cert(1024, [['CN', certname + "." + certdomain], ['DC', certdomain]], certcomment)
    key = OpenSSL::PKey::RSA.new(1024)
    request = OpenSSL::X509::Request.new
    request.version = 0 
    request.subject = OpenSSL::X509::Name.new([
      ['CN', certname + "." + certdomain, OpenSSL::ASN1::UTF8STRING]
    ])  
    request.public_key = key.public_key
    request.sign(key, OpenSSL::Digest::SHA1.new)
    return [ request, key ]
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

  def file_exists (filename)
    return File.file?(filename)
  end

  def can_connect_to (server, port, request, certfile=nil, keyfile=nil)
    uri = URI.parse(server + ":" + port + "/" + request)
    if !certfile.nil?
      cert = File.read(certfile)
      key = File.read(keyfile)
    end
    http = Net::HTTP.new(uri.host, uri.port)
    if !certfile.nil?
      http.use_ssl = true
      http.cert = OpenSSL::X509::Certificate.new(cert)
      http.key = OpenSSL::PKey::RSA.new(key)
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    if response.is_a?(Net::HTTPSuccess)
      return true
    else
      return false
    end
  end

  def submit_csr (server, port, request, csr)
    uri = URI.parse(server + ":" + port + request + File.basename(csr, ".csr"))
    logger.debug("URI: #{uri}")

    file = File.open(csr)
    put_body = file.read
    file.close

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Put.new(uri.request_uri)
    request.body = put_body.to_s
    request["Content-Type"] = "text/plain"
    response = http.request(request)
    if response.is_a?(Net::HTTPSuccess)
      return true
    else
      if response.body =~ /already has a requested certificate/
        return true
      elsif response.body =~ /already has a signed certificate/
        return true
      else
        logger.debug("POST error: #{response.code} - #{response.message} - #{response.body}")
        return false
      end
    end
  end

  def get_signed_cert (server, port, request, csr)
    uri = URI.parse(server + ":" + port + request + File.basename(csr, ".csr") )
    logger.debug("URI: #{uri}")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri, {"Accept" => "s"})
    response = http.request(request)
    if response.is_a?(Net::HTTPSuccess)
      filename = File.dirname(csr) + "/" + File.basename(csr, ".csr") + ".pem"
      save_data_to_file(filename, response.body.to_s)
      return filename
    else
      logger.debug("GET error: #{response.code} - #{response.message} - #{response.body}")
      return false
    end
  end
end
