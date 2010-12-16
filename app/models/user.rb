class User < ActiveRecord::Base
  
  devise :database_authenticatable, :registerable, :token_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :confirmable
  
  has_and_belongs_to_many :roles
  has_many :project_roles
  has_many :projects, :through => :project_roles
  
  validates_uniqueness_of :name, :email, :case_sensitive => false, :scope => :deleted_at
  
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  
  default_scope :conditions => { :deleted_at => nil }

  def any_role?(*roles)
    roles.any?{|role| role?(role)}
  end
  
  def role?(role)
    return !!self.roles.find_by_name( Role.sanitize role )
  end

  def admin?
    self.role?('Admin')
  end
  
  def destroy
    self.update_attribute(:deleted_at, Time.now.utc)
  end

  def self.find_with_destroyed *args
    self.with_exclusive_scope { find(*args) }
  end

  def self.find_only_destroyed
    self.with_exclusive_scope :find => { :conditions => "deleted_at IS NOT NULL" } do
      all
    end
  end

  def short_name
    self.first_name || login
  end
  
  def full_name
    if self.first_name.blank? && self.last_name.blank?
      self.login rescue 'Deleted user'
    else
      ((self.first_name || '') + ' ' + (self.last_name || '')).strip
    end
  end

  def display_name
    h(self.name)
  end
  
  def can_upload?(check_user)
    true
  end
  
end
