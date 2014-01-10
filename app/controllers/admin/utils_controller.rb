class Admin::UtilsController < Admin::AdminController
  # before_filter { |c| c.verify_admin true}
  include Admin::UtilsHelper

  def generate_cert
    if !params['cert'].blank?
      @certname = params['cert']['certname'].blank? ? 'dashboard' : params['cert']['certname']
      @certdomain = params['cert']['certdomain'].blank? ? 'nvisionary' : params['cert']['certdomain']
      @certcomment = params['cert']['certcomment'].blank? ? "Puppet Dashboard" : params['cert']['certcomment']
    else
      @certname = 'dashboard'
      @certdomain = 'nvisionary'
      @certcomment = "Puppet Dashboard"
    end
    if !params['certificate'].blank?
      @certpath = params['certificate']['certpath'].blank? ? "Puppet Dashboard" : params['certificate']['certpath']
      @certkeypath = params['certificate']['certkeypath'].blank? ? "Puppet Dashboard" : params['certificate']['certkeypath']
    else
      @certpath = 'config/ssl/dashboard.pem'
      @certkeypath = 'config/ssl/dashboard.key'
    end

    @cert, @key = create_cert_key(@certname, @certdomain, @certcomment)
 
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
