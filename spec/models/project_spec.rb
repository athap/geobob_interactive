# == Schema Information
#
# Table name: projects
#
#  id                 :integer         not null, primary key
#  project_type_id    :integer
#  name               :string(255)
#  description        :text
#  deadline           :datetime
#  aasm_state         :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  comment_count      :integer         default(0)
#  created_at         :datetime
#  updated_at         :datetime
#  app_items          :text
#

require '../spec_helper'

class ProjectTest < ActiveSupport::TestCase

  describe "a project instance" do
    should_belong_to :project_type
    should_have_many :project_roles
    should_have_many :users
    
    should_validate_presence_of :name
    should_validate_presence_of :description

    
    should_not_allow_mass_assignment_of :created_at, :updated_at
    
    describe "aasm" do
      before do
        @project = Factory(:project)
      end
      it "should be in the inital state" do
        assert @project.new?
      end
      it "should move to the completed state" do
        assert @project.finish!
        assert @project.finished?
      end
    end
    
  end

  describe "named scope" do
    describe "by_name" do
      before do
        Project.delete_all
        @first = Factory(:project, :name => 'a')
        @second = Factory(:project, :name => 'b')
      end
      it "should sort by name" do
        assert_equal @first, Project.by_name[0]
        assert_equal @second, Project.by_name[1]
      end    
    end
    describe "recent" do
      before do
        Project.delete_all
        @recent = Factory(:project)
        @not_recent = Factory(:project, :created_at => 10.weeks.ago)
      end
      it "should get recent Projects" do
        assert Project.recent.include?(@recent)
      end
      it "should not get recent Projects" do
        assert !Project.recent.include?(@not_recent)
      end
    end
    describe "newest" do
      before do
        Project.delete_all
        @first = Factory(:project, :created_at => 1.day.ago)
        @second = Factory(:project, :created_at => 1.week.ago)
      end
      it "should sort by created_at" do
        assert_equal @first, Project.newest[0]
        assert_equal @second, Project.newest[1]
      end
    end
  end
  
  describe "export" do
    before do
      @project = Factory(:project)
      @fact1 = Factory(:fact, :project => @project)
      @fact2 = Factory(:fact, :project => @project)
      @path = File.join(RAILS_ROOT, 'tmp')
    end
    it "should export zip file" do
      zip_file_path = @project.zip(@path)
      assert File.exists? zip_file_path
    end
  end
  
end


