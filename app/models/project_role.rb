# == Schema Information
#
# Table name: project_roles
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  project_id :integer
#  role       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class ProjectRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
end
