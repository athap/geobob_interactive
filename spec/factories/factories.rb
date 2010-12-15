Factory.define :project_type do |f|
  f.name { Factory.next(:name) }
end

Factory.define :project do |f|
  f.project_type { |a| a.association(:project_type) }
  f.name { Factory.next(:name) }
  f.description { Factory.next(:description) }
  f.deadline DateTime.now + 1.week
  f.aasm_state 'new'
end

Factory.define :fact do |f|
  f.project { |a| a.association(:project) }
  f.content { Factory.next(:description) }
  f.aasm_state 'new'
  f.location 'Utah State University, Logan, UT'
  f.title { Factory.next(:title) }
end

# Factory.define :app_map
#   f.location 'Utah State University, Logan, UT'
#  f.zoom_level 10
# end
