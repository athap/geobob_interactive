class AppMapsController < ApplicationController
                
  before_filter :authenticate_user!
  before_filter :setup_app_map, :only => [:edit, :update, :destroy]
          
  def create
    @app_map = AppMap.new(params[:app_map])
    @item_id = params[:item_id]
    @success = @app_map.save
    respond_to do |format|
      format.js { render :template => false }
    end
  end
  
  def edit
    @map_icons = @app_map.tags
    @available_icons = ActsAsTaggableOn::Tag.all - @map_icons
    render :layout => false
  end
  
  def update
    if params[:read_google_map]
      @app_map.read_google_map
    else
      @success = @app_map.update_attributes(params[:app_map])
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def destroy
    @app_map.destroy
    respond_to do |format|
      format.js { render :template => false }
    end
  end
  
  protected
    def setup_app_map
      @app_map = AppMap.find(params[:id])
    end
    
end