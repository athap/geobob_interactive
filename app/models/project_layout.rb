class ProjectLayout < ActiveRecord::Base
  scope :by_sort, :order => "sort ASC"
end