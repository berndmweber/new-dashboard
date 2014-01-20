class Admin::UtilsController < Admin::AdminController
  # before_filter { |c| c.verify_admin true}
  include Admin::UtilsHelper

  def generate_csr
    if !params['cert'].blank?
      @certname = params['cert']['certname'].blank? ? 'dashboard' : params['cert']['certname']
      @certdomain = params['cert']['certdomain'].blank? ? 'nvisionary.com' : params['cert']['certdomain']
    else
      @certname = 'dashboard'
      @certdomain = 'nvisionary.com'
    end
    if !params['certificate'].blank?
      @certpath = params['certificate']['certpath'].blank? ? "config/ssl/#{@certname}.#{@certdomain}.csr" : params['certificate']['certpath']
      @certkeypath = params['certificate']['certkeypath'].blank? ? "config/ssl/#{@certname}.#{@certdomain}.key" : params['certificate']['certkeypath']
    else
      @certpath = "config/ssl/#{@certname}.#{@certdomain}.csr"
      @certkeypath = "config/ssl/#{@certname}.#{@certdomain}.key"
    end

    @cert, @key = create_cert_key(@certname, @certdomain)
 
    respond_to do |format|
      format.html # generate_cert.html.erb
      format.js { render :layout => false }
    end
  end

  def save_to_file
    @certpath = params['certificate']['certpath']
    @certdata = params['certificate']['cert']

    save_data_to_file(@certpath, @certdata)

    respond_to do |format|
      format.js { render :layout => false }
    end
  end
end
