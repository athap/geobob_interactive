class AppLinksController < ApplicationController
                
  before_filter :authenticate_user!
  before_filter :setup_app_link, :only => [:edit, :update, :destroy]
          
  def create
    @app_link = AppLink.new(params[:app_link])
    @item_id = params[:item_id]
    @success = @app_link.save
    respond_to do |format|
      format.js { render :template => false }
    end
  end
  
  def edit
    render :layout => false
  end
  
  def update
    @success = @app_link.update_attributes(params[:app_link])
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def destroy
    @app_link.destroy
    respond_to do |format|
      format.js { render :template => false }
    end
  end
  
  protected
    def setup_app_link
      @app_link = AppLink.find(params[:id])
    end
    
end