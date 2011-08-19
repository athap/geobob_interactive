class FactsController < ApplicationController
                
  before_filter :authenticate_user!
  before_filter :setup_parent, :only => [:index, :sort, :new]
  
  uses_tiny_mce(:options => GlobalConfig.map_mce_options,
                :only => [:edit])
  
  def index
    @facts = @parent.facts.by_position
    respond_to do |format|
      format.js { render :layout => false }
    end
  end
  
  def sort
    # Sortable lists with jQuery:
    # http://awesomeful.net/posts/47-sortable-lists-with-jquery-in-rails
    @facts = @parent.facts.by_position
    @facts.each do |fact|
      fact.position = params['fact'].index(fact.id.to_s) + 1
      fact.save
    end
    @facts = @parent.facts.by_position # Reload the facts
    respond_to do |format|
      format.js { render :layout => false }
    end
  end
  
  def new
    @factable = @parent
    @fact = @parent.facts.new
    setup_project_layout    
    if @project.project_layout.view == 'gpsrs'
      @fact.add_default_questions
      @fact.add_default_contents
    end
    respond_to do |format|
      format.html
      format.js do
        @enable_js = true
        render :layout => false
      end
    end
  end
                  
  def create
    @factable = params[:factable_type].to_s.constantize.find(params[:factable_id])
    @fact = @factable.facts.build(params[:fact])
    @gprs = true if params[:spatial]
    @fact.set_lat_lng_from_location unless @gprs # WARNING set_lat_lng_from_location  gelocates addresses.  Even if you give it a lat,lng it will find the nearest valid address
    if @success = @fact.save
      @message = "Successfully created."
      @categories = @fact.categories
    else
      if @fact.content
        @message = "There was a problem adding the fact"
      else
        @message = "There was a problem adding your information"
      end
    end
    respond_to do |format|
      format.html { redirect_to(@fact.project) }
      format.js { render :layout => false }
    end
  end
  
  def edit
    @fact = Fact.find(params[:id])
    @factable = @fact.factable
    setup_project_layout
    respond_to do |format|
      format.html
      format.js do
        @enable_js = true
        render :layout => false
      end
    end
  end
  
  def update
    @fact = Fact.find(params[:id])
    if params[:horizontal_offset] && params[:vertical_offset]
      @full_update = false
      @gpsrs = true
      success = @fact.update_attributes(:horizontal_offset => params[:horizontal_offset], :vertical_offset => params[:vertical_offset])
    elsif params[:lat] && params[:lng]
      @full_update = false
      success = @fact.update_attributes(:lat => params[:lat], :lng => params[:lng])
    else
      @full_update = true
      @fact.attributes = params[:fact]
      @gpsrs = true if params[:spatial]
      @fact.set_lat_lng_from_location unless @gpsrs # WARNING set_lat_lng_from_location  gelocates addresses.  Even if you give it a lat,lng it will find the nearest valid address
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
    @gpsrs = true if params[:spatial]
    @factable = @fact.factable
    @fact.destroy
    respond_to do |format|
      format.html { redirect_to(@factable) }
      format.js { render :layout => false }
    end
  end
  
  protected

    def setup_project_layout
      if @factable && @factable.respond_to?(:project_layout)
        @project = @factable
        if(@project.project_layout.view == 'gpsrs')
          @custom_view = @project.project_layout.view
        end
      end
    end
    
end
