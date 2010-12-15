class ProjectLayout < ActiveRecord::Base
  named_scope :by_sort, :order => "sort ASC"
end