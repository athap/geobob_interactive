class Role < ActiveRecord::Base
  has_and_belongs_to_many :users

  def self.sanitize role
    role.to_s.humanize.split(' ').each{ |word| word.capitalize! }.join(' ')
  end
end
