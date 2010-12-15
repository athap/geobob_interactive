require '../spec_helper'

class FactsControllerTest < ActionController::TestCase
  
  tests FactsController
  
  describe "facts controller" do
    before do
      @project = Factory(:project)
      @fact = Factory(:fact)
    end
    should_require_login :edit => :get, :create => :post, :destroy => :delete, :update => :put, :login_url => '/login'

    describe "logged in" do
      before do
        @user = Factory(:user)
        activate_authlogic
        login_as @user
      end
      describe "POST create" do
        before do
          post :create, :project_id => @project.id, :fact => { :title => 'test', :content => 'content', :location => 'Utah State University, Logan, UT' }
        end
        should_redirect_to("project") { assigns(:fact).project } 
      end
      describe "POST create (js)" do
        before do
          post :create, :project_id => @project.id, :fact => { :title => 'test', :content => 'content', :location => 'Utah State University, Logan, UT' }, :format => 'js'
        end
        should_respond_with :success
        it "should not have errors on the fact object" do
          assert assigns(:fact).errors.empty?
        end
      end
      describe "GET edit" do
        describe "html" do
          before do
            @fact = Factory(:fact)
            get :edit, :id => @fact.to_param
          end
          should_not_set_the_flash
          should_respond_with :success
          should_render_template :edit
        end
        describe "js" do
          before do
            @fact = Factory(:fact)
            get :edit, :id => @fact.to_param, :format => 'js'
          end
          should_not_set_the_flash
          should_respond_with :success
          should_render_template :edit
        end
      end
      describe "PUT update" do
        describe "html" do
          before do
            @fact = Factory(:fact)
            put :update, :id => @fact.to_param, :fact => {:title => 'test'}
          end
          should_redirect_to("project") { assigns(:fact).project } 
        end
        describe "js" do
          before do
            @fact = Factory(:fact)
            put :update, :id => @fact.to_param, :fact => {:title => 'test'}, :format => 'js'
          end
          should_respond_with :success
          should_render_template :update
        end
        describe "by lat lng" do
          describe "html" do
            before do
              @fact = Factory(:fact)
              put :update, :id => @fact.to_param, :fact => {:title => 'test'}
            end
            should_redirect_to("project") { assigns(:fact).project }
          end
          describe "js" do
            before do
              @fact = Factory(:fact)
              put :update, :id => @fact.to_param, :fact => {:title => 'test'}, :format => 'js'
            end
            should_respond_with :success
            should_render_template :update
          end
        end
      end
      describe "DELETE destroy" do
        before do
          @fact = Factory(:fact)
          delete :destroy, :id => @fact.to_param
        end
        should_redirect_to("facts") { assigns(:fact).project }
      end
    end

  end

end