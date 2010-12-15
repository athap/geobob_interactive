class ApplicationController < ActionController::Base
  protect_from_forgery
  
  layout 'default'
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access Denied"
    redirect_to root_url
  end
  
  # called by Admin::Muck::BaseController to check whether or not the
  # user should have access to the admin UI
  def admin_access?
    access_denied unless admin?
  end

  def setup_paging
    @page = (params[:page] || 1).to_i
    @page = 1 if @page < 1
    @per_page = (params[:per_page] || (Rails.env=='test' ? 1 : 40)).to_i
  end

  def do_not_include_json_root
    old_include_root_in_json = ActiveRecord::Base.include_root_in_json
    ActiveRecord::Base.include_root_in_json = false
    result = yield
    ActiveRecord::Base.include_root_in_json = old_include_root_in_json
    result
  end
  
  def do_not_include_json_root
    old_include_root_in_json = ActiveRecord::Base.include_root_in_json
    ActiveRecord::Base.include_root_in_json = false
    yield
    ActiveRecord::Base.include_root_in_json = old_include_root_in_json
  end
  
end
