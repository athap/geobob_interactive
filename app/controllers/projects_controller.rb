class ProjectsController < ApplicationController
                
  before_filter :authenticate_user!, :except => [:show, :index]
  before_filter :get_project, :only => [:show, :edit, :destroy, :interface, :details, :content, :build]
  # added by Atul
  before_filter :verify_user, :only => [:edit, :destroy]
  
  layout :choose_layout
                
  def index
    @user = User.find(params[:user]) if params[:user]
    #below line added by Atul
    @online_users = User.online_users
    @project = Project.new
    if @user
      @projects = @user.projects
    else
      @projects = Project.by_name.paginate(:page => @page, :per_page => @per_page)
    end
    respond_to do |format|
      format.html
      format.xml  { render :xml => @projects }
      format.json { render :json => @projects.to_json }
    end
  end

  def show
    @facts = @project.facts.by_position
    @tags = @project.tags.all(:order => 'name')
    @fact = Fact.new
    @page_title = @project.name
    respond_to do |format|
      format.html { redirect_to edit_project_path(@project) }
      format.xml  { render :xml => @project }
      format.json { render :json => { :project => @project, :facts => @facts.collect{|fact| fact.json_hash}}.to_json }
    end
  end
  
  def new
    @project = Project.new
    respond_to do |format|
      format.html
      format.xml  { render :xml => @project }
    end
  end

  def edit
  end
  
  def interface
    render
  end
  
  def icons
    @project = Project.find(params[:id])
    @project_icons = @project.tags
    @available_icons = ActsAsTaggableOn::Tag.all - @project_icons
  end
  
  def details
    # This is a bit of a hack since updates should be handled by update but we need to make sure and capture the layout change if the user changes it
    @project.update_attributes!(params[:project]) if !@project.blank?
    @project ||= Project.new(params[:project])
  end
  
  def content
    @icons = []
    @icons.concat(@project.app_maps)
    @icons.concat(@project.app_links)
    @icons.concat(@project.app_feeds)
    @icons.sort {|a,b| b.sort <=> a.sort}
    if @project.project_layout.view == 'gpsrs'
      if @project.facts.empty?
        # create a default starting point
        @fact = @project.facts.create(:title => 'start', :content => 'This is your starting point', :vertical_offset => 0, :horizontal_offset => 0)
      else
        @fact = Fact.new
      end
      @fact.add_default_questions
      @fact.add_default_contents
    end
  end
  
  def build
    render
  end
  
  def export
    @project = Project.find(params[:id])
    send_file @project.zip("#{::Rails.root.to_s}/public/projects/"), :type => 'application/zip'
  end
  
  def create  
    @project = current_user.projects.create(params[:project])
    @project.current_editor = current_user
    #ProjectRole.create(:user_id => current_user.id, :project_id => @project.id)
    respond_to do |format|
      if @project
        #flash[:notice] = 'Project was successfully created.'
        format.html { redirect_to content_project_path(@project) }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "details" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @project = Project.find(params[:id])
    if params[:read_google_map]
      @project.read_google_map
    else
      @project.current_editor = current_user
      success = @project.update_attributes(params[:project])
    end
    
    respond_to do |format|
      if success
        format.html do
          #flash[:notice] = 'Project was successfully updated.'
          redirect_to content_project_path(@project)
        end
        format.js { render :layout => false }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.js do
          @errors = @project.errors.full_messages.to_sentence
          render :template => false
        end
        format.xml { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
    
    def get_project
     @project = Project.find(params[:id]) rescue nil     
    end
    
    def verify_user
      unless(current_user.admin? || current_user.owner?(params[:id]))
        redirect_to(projects_url, :notice => 'Access denied. You can edit projects created by you only')
      end
    end
    
    def choose_layout
      'default'
    end
    
    # def facts_to_categories(facts)
    #   categories = {}
    #   facts.each do |fact|
    #     if fact.tags.length > 0
    #       fact.tags.each do |tag|
    #         categories[tag.name.to_sym] = [] unless categories.has_key?(tag.name.to_sym)
    #         categories[tag.name.to_sym] << fact
    #       end
    #     else
    #       categories[:uncategorized] = [] unless categories.has_key?(:uncategorized)
    #       categories[:uncategorized] << fact
    #     end
    #   end
    #   categories
    # end
    
end
