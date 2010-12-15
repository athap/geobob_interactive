class FactsController < ApplicationController
                
  before_filter :authenticate_user!
  uses_tiny_mce(:options => GlobalConfig.map_mce_options,
                :only => [:edit])
                
  def create
    @project = Project.find(params[:project_id])
    @fact = @project.facts.build(params[:fact])
    @fact.set_lat_lng_from_location # WARNING set_lat_lng_from_location  gelocates addresses.  Even if you give it a lat,lng it will find the nearest valid address
    if @success = @fact.save
      @message = "#{truncate_fact(@fact)} successfully created."
      @categories = @fact.categories
    else
      @message = "There was a problem adding #{truncate_fact(@fact)}"
    end
    respond_to do |format|
      format.html { redirect_to(@fact.project) }
      format.js { render :template => false }
    end
  end
  
  def edit
    @fact = Fact.find(params[:id])
    @project = @fact.project
    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
  end
  
  def update
    @fact = Fact.find(params[:id])
    if params[:lat] && params[:lng]
      @full_update = false
      success = @fact.update_attributes(:lat => params[:lat], :lng => params[:lng])
    else
      @full_update = true
      @fact.attributes = params[:fact]
      @fact.set_lat_lng_from_location # WARNING set_lat_lng_from_location  gelocates addresses.  Even if you give it a lat,lng it will find the nearest valid address
      success = @fact.save
    end

    # Output message if needed.
    if !success
      @message = "There was a problem updating #{@fact.title}: #{@fact.errors.full_messages.to_sentence}"
    end
    
    @icon = @fact.icon
    respond_to do |format|
      format.html { redirect_to(@fact.project) }
      format.js { render :layout => false }
    end
  end

  def destroy
    @fact = Fact.find(params[:id])
    @project = @fact.project
    @fact.destroy
    respond_to do |format|
      format.html { redirect_to(@project) }
      format.js { render :template => false }
    end
  end
  
  protected
    def truncate_fact(fact)
      "#{ActionController::Base.helpers.strip_tags(fact.content)[0...30]} ..."
    end

end