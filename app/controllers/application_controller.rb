class ApplicationController < ActionController::Base
  protect_from_forgery
  
  layout 'default'
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access Denied"
    redirect_to root_url
  end
  
  protected

    # called by Admin::Muck::BaseController to check whether or not the
    # user should have access to the admin UI
    def admin_access?
      access_denied unless current_user.admin?
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
  
    # Attempts to create an @parent object using params
    # or the url.
    # scope:  Friendly id can require a scope to find the object.  Pass the scope as needed.
    # ignore: Names to ignore.  For example if the url is /foo/1/bar?thing_id=1
    #         you might want to ignore thing_id so pass :thing.
    def setup_parent(args = {})
      @parent = get_parent(args)
      if @parent.blank?
        render :text => "Missing Parent"
        return false
      end
    end

    # Tries to get parent using parent_type and parent_id from the url.
    # If that fails and attempt is then made using find_parent
    # parameters:
    # scope:  Friendly id can require a scope to find the object.  Pass the scope as needed.
    # ignore: Names to ignore.  For example if the url is /foo/1/bar?thing_id=1
    #         you might want to ignore thing_id so pass :thing.
    def get_parent(args = {})
      if params[:parent_type].blank? || params[:parent_id].blank?
        find_parent(args)
      else
        klass = params[:parent_type].to_s.constantize
        if args.has_key?(:scope)
          klass.find(params[:parent_id], :scope => args[:scope])
        else
          klass.find(params[:parent_id])
        end
      end
    end
  
    # Searches the params to try and find an entry ending with _id
    # ie article_id, user_id, etc.  Will return the first value found.
    # parameters:
    # scope:  Friendly id can require a scope to find the object.  Pass the scope as needed.
    # ignore: Names to ignore.  For example if the url is /foo/1/bar?thing_id=1
    #         you might want to ignore thing_id so pass 'thing' to be ignored.
    def find_parent(args = {})
      ignore = args.delete(:ignore) || []
      ignore.flatten!
      params.each do |name, value|
        if name =~ /(.+)_id$/
          if !ignore.include?($1)
            if args.has_key?(:scope)
              return $1.classify.constantize.find(value, :scope => args[:scope])
            else
              return $1.classify.constantize.find(value)
            end
          end
        end
      end
      nil
    end
    
end
