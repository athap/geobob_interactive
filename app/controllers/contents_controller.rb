class ContentsController < ApplicationController
                
  before_filter :authenticate_user!
  
  def sort
    @fact = Fact.find(params[:fact_id])
    # Sortable lists with jQuery:
    # http://awesomeful.net/posts/47-sortable-lists-with-jquery-in-rails
    @contents = @fact.contents.by_position
    @contents.each do |content|
      content.position = params['content'].index(content.id.to_s) + 1
      content.save
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end
  
end