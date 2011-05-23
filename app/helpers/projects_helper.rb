module ProjectsHelper

  def empty_project
    return true if @project.blank?
    return true if @project.id.blank?
    false
  end
  
  def app_background(project, include_style = true, no_background = false, include_border = false)
    style = "height:#{project.height || 500}px;"
    style << "width:#{project.width || 500}px;"
    if !no_background && project.background_image
      style << %Q{background-image:url('#{project.background_image.url(:background)}');}
    end
    if include_border
      style << "border:solid 2px #000;"
    end
    if include_style
      %Q{style="#{style}"}
    else
      style
    end
  end
  
  def app_splash(project, include_style = true)
    if project.splash_image
      back = %Q{background-image:url('#{project.splash_image.url(:background)}');}
      if include_style
        %Q{style="#{back}"}
      else
        back
      end
    end
  end
  
  def output_icons(app_items)
    app_items.each do |app_item|
      concat(render("#{app_item.class.to_s.tableize.pluralize}/#{app_item.class.to_s.tableize.singularize}", :app_item => app_item))
    end
  end
  
  def calculate_gpsrs_position(fact)
    height = fact.factable.height || 400
    width = fact.factable.width || 276
    height = height/2
    width = width/2
    v = fact.vertical_offset || 0
    h = fact.horizontal_offset || 0
    v = height - v
    h = h + width
    %Q{style="top:#{v}px;left:#{h}px;position:absolute;"}
  end
  
  def content_is_question_css(content)
    if content.is_question?
      'display:block;'
    else
      'display:none;'
    end
  end
  
end