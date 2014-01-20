class Admin::PuppetmastersController < Admin::AdminController
  load_and_authorize_resource
  include Admin::UtilsHelper

  # GET /puppetmasters
  # GET /puppetmasters.json
  def index
    @puppetmasters = Puppetmaster.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @puppetmasters }
    end
  end

  # GET /puppetmasters/1
  # GET /puppetmasters/1.json
  def show
    @puppetmaster = Puppetmaster.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @puppetmaster }
    end
  end

  # GET /puppetmasters/new
  # GET /puppetmasters/new.json
  def new
    @puppetmaster = Puppetmaster.new
    @puppetmaster.url = 'https://' if @puppetmaster.url.blank?
    @puppetmaster.port = '8140' if @puppetmaster.port.blank?
    @puppetmaster.sslCsr = 'config/ssl/dashboard.nvisionary.com.csr' if @puppetmaster.sslCsr.blank?
    @puppetmaster.sslKey = 'config/ssl/dashboard.nvisionary.com.key' if @puppetmaster.sslKey.blank?
    @puppetmaster.customer_id = params[:customer] if @puppetmaster.customer_id.blank?

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @puppetmaster }
    end
  end

  # GET /puppetmasters/1/edit
  def edit
    @puppetmaster = Puppetmaster.find(params[:id])
  end

  # POST /puppetmasters
  # POST /puppetmasters.json
  def create
    @puppetmaster = Puppetmaster.new(params[:puppetmaster])

    respond_to do |format|
      if @puppetmaster.save
        format.html { redirect_to admin_customer_path(@puppetmaster.customer_id), notice: 'Puppetmaster was successfully created.' }
        format.json { render json: @puppetmaster, status: :created, location: @puppetmaster }
      else
        format.html { render action: "new" }
        format.json { render json: @puppetmaster.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /puppetmasters/1
  # PUT /puppetmasters/1.json
  def update
    @puppetmaster = Puppetmaster.find(params[:id])

    respond_to do |format|
      if @puppetmaster.update_attributes(params[:puppetmaster])
        format.html { redirect_to admin_puppetmaster_path(@puppetmaster), notice: 'Puppetmaster was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @puppetmaster.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /puppetmasters/1
  # DELETE /puppetmasters/1.json
  def destroy
    @puppetmaster = Puppetmaster.find(params[:id])
    customer = @puppetmaster.customer_id
    @puppetmaster.destroy

    respond_to do |format|
      format.html { redirect_to admin_customer_path(customer) }
      format.json { head :no_content }
    end
  end

  def check_connection_status
    @puppetmaster = Puppetmaster.find(params[:id])
    if file_exists(@puppetmaster.sslCert)
      @connection_status = can_connect_to(@puppetmaster.url, @puppetmaster.port, "/production/facts/puppetmaster.nvisionary.com", @puppetmaster.sslCert, @puppetmaster.sslKey) ? "Connected" : "Not Connected"
    else
      @connection_status = "Need pairing"
    end

    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def pair_with_puppetmaster
    @puppetmaster = Puppetmaster.find(params[:id])
    if file_exists(@puppetmaster.sslCert)
      @connection_status = "Connected"
    else
      @connection_status = submit_csr(@puppetmaster.url, @puppetmaster.port, "/production/certificate_request/", @puppetmaster.sslCsr) ? "Request sent" : "Error"
      if @connection_status == "Request sent"
        @connection_status = get_signed_cert(@puppetmaster.url, @puppetmaster.port, "/production/certificate/", @puppetmaster.sslCsr)
        if !@connection_status
          @connection_status = "Request sent"
        else
          @puppetmaster.update_attribute(:sslCert, @connection_status)
          @connection_status = "Connected"
        end
      end
    end

    respond_to do |format|
      format.js { render :layout => false }
    end
  end
end
