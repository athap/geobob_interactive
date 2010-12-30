module ActiveRecord
  module Acts
    module ModelExtensions
  
       def dom_id(prefix='')
        display_id = new_record? ? "new" : id.to_s 
        prefix.to_s <<( '_') unless prefix.blank?
        prefix.to_s << "#{self.class.name.underscore}"
        prefix != :bare ? "#{prefix.to_s.underscore}_#{display_id}" : display_id
      end

    end
  end
end
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::ModelExtensions }
