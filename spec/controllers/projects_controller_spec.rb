require '../spec_helper'

describe ProjectsController do
  
  describe "projects controller" do
    before do
      @project = Factory(:project)
    end
    should_require_login :new => :get, :edit => :get, :create => :post, :destroy => :delete, :update => :put, :login_url => '/login'

    describe "logged in" do
      before do
        @user = Factory(:user)
        activate_authlogic
        login_as @user
      end
      describe "GET index" do
        before do
          get :index
        end
        should_not_set_the_flash
        should_respond_with :success
        should_render_template :index
      end
      describe "GET show" do
        before do
          @project = Factory(:project)
          get :show, :id => @project.to_param
        end
        should_not_set_the_flash
        should_respond_with :success
        should_render_template :show
      end
      describe "GET new" do
        before do
          get :new
        end
        should_not_set_the_flash
        should_respond_with :success
        should_render_template :new
      end
      describe "GET edit" do
        before do
          @project = Factory(:project)
          get :edit, :id => @project.to_param
        end
        should_not_set_the_flash
        should_respond_with :success
        should_render_template :edit
      end
      describe "PUT update" do
        before do
          @project = Factory(:project)
          put :update, :id => @project.to_param, :project => {:name => 'test'}
        end
        should_redirect_to("project") { @project } 
      end
      describe "POST create" do
        before do
          post :create, :project => {:name => 'test', :description => 'a description' }
        end
        should_redirect_to("project") { assigns(:project) } 
      end
      describe "DELETE destroy" do
        before do
          @project = Factory(:project)
          delete :destroy, :id => @project.to_param
        end
        should_redirect_to("projects") { projects_path }
      end
    end

  end

end