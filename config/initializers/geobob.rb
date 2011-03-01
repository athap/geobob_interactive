if defined?(ActiveRecord)
  # Don't Include Active Record class name as root for JSON serialized output.
  ActiveRecord::Base.include_root_in_json = false
end