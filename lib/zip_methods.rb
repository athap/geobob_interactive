module ZipMethods

  def project_for_zip(zip_file, output_file_name)
    project = { :project => self, :facts => self.facts.collect{|fact| fact.json_hash}}.to_json
    zip_file.get_output_stream(output_file_name) {|f| f.puts project }
  end
  
  def facts_for_zip(zip_file, output_file_name)
    facts = { :annotation => self.facts.collect{|fact| fact.json_hash} }.to_json
    zip_file.get_output_stream(output_file_name) {|f| f.puts facts }
  end

  def tags_for_zip(zip_file, output_file_name)
    tags = { :category => ActsAsTaggableOn::Tag.all(:order => 'name').collect{|tag| { :title => tag.name, :icon => tag.icon }}.flatten }.to_json
    zip_file.get_output_stream(output_file_name) { |f| f.puts tags }
  end
  
end