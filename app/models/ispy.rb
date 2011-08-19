class Ispy < ActiveRecord::Base
  belongs_to :content
  
  attr_accessible :position_x, :position_y, :trigger_x, :trigger_y, :checker_x, :checker_y, :checker_size
  
  def json_hash
    {
      :posx => self.position_x,
      :posy => self.position_y,
      :triggerx => self.trigger_x,
      :triggery => self.trigger_y,
      :checker_posx => self.checker_x,
      :checker_posy => self.checker_y,
      :checker_size => self.checker_size,
    }
  end
end
