module ApplicationHelper
  include ActsAsTaggableOn::TagsHelper
  
  def http_protocol(use_ssl = request.ssl?)
    (use_ssl ? "https://" : "http://")
  end
  
  def current_tag_class(object, tag)
    'class="current_tag"' if object.tags.include?(tag)
  end
  
  def show_icon_tag?(new_fact)
    if new_fact
      'style="display:none;"'
    end
  end
  
  def output_errors(title, options = {}, fields = nil)
    return if fields.blank?
    fields = [fields] unless fields.is_a?(Array)
    field_errors = render(:partial => 'shared/field_error', :collection => fields)
    css_class = "class=\"#{options[:class] || 'error'}\"" unless options[:class].nil?
    if !field_errors.empty?
      render(:partial => 'shared/error_box', :locals => { :title => title,
                                                          :field_errors => field_errors,
                                                          :css_class => css_class})
    end
  end
  
  def output_errors_ajax(dom_id, title = '', options = { :class => 'notify-box' }, fields = nil, decode_html = true)
    render :partial => 'shared/output_ajax_messages', :locals => {:fields => fields,
                                                                  :title => title,
                                                                  :options => options,
                                                                  :dom_id => dom_id,
                                                                  :decode_html => decode_html }
  end
      
  def output_message_container(message_id = 'message_id', message_container_id = 'errorExplanation', css_class = 'notify-box')
    render :partial => 'shared/message_container', :locals => { :message_id => message_id, 
                                                                :message_container_id => message_container_id, 
                                                                :css_class => css_class }
  end
  
end



# Output flash and object errors
def output_errors(title, options = {}, fields = nil, flash_only = false)
  fields = [fields] unless fields.is_a?(Array)
  flash_html = render(:partial => 'shared/flash_messages')
  flash.clear
  css_class = "class=\"#{options[:class] || 'error'}\"" unless options[:class].nil?
  field_errors = render(:partial => 'shared/field_error', :collection => fields)

  if flash_only || (!flash_html.empty? && field_errors.empty?)
    # Only flash.  Don't render errors for any fields
    render(:partial => 'shared/flash_error_box', :locals => {:flash_html => flash_html, :css_class => css_class})
  elsif !field_errors.empty?
    # Field errors and/or flash
    render(:partial => 'shared/error_box', :locals => {:title => title,
      :flash_html => flash_html,
      :field_errors => field_errors,
      :css_class => css_class,
      :extra_html => options[:extra_html]})
  else
    #nothing
    ''
  end
end
