# == Schema Information
#
# Table name: facts
#
#  id                 :integer         not null, primary key
#  project_id         :integer
#  content            :text
#  location           :string(255)
#  lat                :decimal(15, 10)
#  lng                :decimal(15, 10)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  aasm_state         :string(255)
#  photo_file_size    :integer
#  created_at         :datetime
#  updated_at         :datetime
#  title              :string(255)
#  subtitle           :string(255)     default("")
#

require '../spec_helper'

class FactTest < ActiveSupport::TestCase

  describe "a fact instance" do
    should_belong_to :project
    
    should_validate_presence_of :title
    should_validate_presence_of :location
    should_validate_presence_of :content
    should_validate_presence_of :project_id
    
    describe "aasm" do
      before do
        @fact = Factory(:fact)
      end
      it "should be in the inital state" do
        assert @fact.new?
      end
      it "should move to the approved state" do
        assert @fact.approve!
        assert @fact.approved?
      end
    end
    
  end

  describe "categories" do
    before do
      @fact = Factory(:fact, :tag_list => 'test, blue, red')
      @fact_no_categories = Factory(:fact)
    end
    it "should have categories: test, blue, red" do
      assert_equal %w{test blue red}, @fact.categories
    end
    it "should be uncategorized" do
      assert_equal %w{uncategorized}, @fact_no_categories.categories
    end
  end
  
  describe "icon" do
    before do
      @tag = ActsAsTaggableOn::Tag.new(:name => 'icon_test')
      @tag.icon = 'noicon.png'
      @tag.save!
      @fact = Factory(:fact, :tag_list => 'icon_test')
      @default_fact = Factory(:fact)
    end
    it "should have noicon.png" do
      assert_equal 'noicon.png', @fact.icon
    end
    it "should have default icon" do
      assert_equal 'http://maps.google.com/mapfiles/marker.png', @default_fact.icon
    end
  end
  
  describe "location" do
    describe "set using lat and lng" do
      before do
        @fact = Factory(:fact)
        @fact.location = "41.739620009860865,-111.77853909873657"
        @fact.set_lat_lng_from_location
      end
      it "should not geocode lat location" do
        assert_equal "41.7396200098609", @fact.lat.to_s
      end
      it "should not geocode lng location" do
        assert_equal "-111.778539098737", @fact.lng.to_s
      end
    end
    describe "set using address" do
      before do
        @fact = Factory(:fact)
        @fact.location = "Utah State University, Logan, UT"
        @fact.set_lat_lng_from_location
      end
      it "should geocode lat location" do
        assert_equal "41.7521719", @fact.lat.to_s
        assert_equal "-111.810653", @fact.lng.to_s
      end
    end
  end
  
  describe 'json_hash' do
    before do
      @fact = Factory(:fact, :id => 1001,
                             :title => 'json_hash_test',
                             :lat => 41.7521719)
    end
    it "should generate a json hash" do
      assert_equal 1001, @fact.json_hash[:id]
      assert_equal 'json_hash_test', @fact.json_hash[:title]
      assert_equal 41.7521719, @fact.json_hash[:latitude]
    end
  end
  
end
