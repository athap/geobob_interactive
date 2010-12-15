class DefaultController < ApplicationController

  def index
    @dom_id_suffix = '_home'
    @page_title = "Geobob: Make Your Own App"
    respond_to do |format|
      format.html { render }
    end
  end

  def about
    @page_header_text = 'About Us'
    respond_to do |format|
      format.html { render }
    end
  end
  
  def demos
    @page_header_text = 'Example'
    respond_to do |format|
      format.html { render }
    end
  end
  
  def contact
    @page_header_text = 'Contact'
    return unless request.post?
    body = []
    params.each_pair do |k,v|
      if !['authenticity_token', 'action', 'controller'].include?(k) 
        body << "#{k}: #{v}"
      end
    end
    BasicMailer.deliver_mail(:subject => I18n.t("contact.contact_response_subject", :application_name => GlobalConfig.application_name), :body=>body.join("\n"))
    flash[:notice] = I18n.t('general.thank_you_contact')
    redirect_to contact_url    
  end

  def sitemap
    respond_to do |format|
      format.html { render }
    end
  end

  def ping
    user = User.first
    render :text => 'we are up'
  end
  
end
