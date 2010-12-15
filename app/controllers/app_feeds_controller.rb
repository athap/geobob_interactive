class AppFeedsController < ApplicationController
                
  before_filter :authenticate_user!
  before_filter :setup_app_feed, :only => [:edit, :update, :destroy]
          
  def create
    @app_feed = AppFeed.new(params[:app_feed])
    @item_id = params[:item_id]
    @success = @app_feed.save
    respond_to do |format|
      format.js { render :template => false }
    end
  end
  
  def edit
    render :layout => false
  end
  
  def update
    @success = @app_feed.update_attributes(params[:app_feed])
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def destroy
    @app_feed.destroy
    respond_to do |format|
      format.js { render :template => false }
    end
  end
  
  protected
    def setup_app_feed
      @app_feed = AppFeed.find(params[:id])
    end
    
end