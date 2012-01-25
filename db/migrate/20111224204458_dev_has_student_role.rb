class DevHasStudentRole < ActiveRecord::Migration
  def self.up
    user = User.where(:email => 'dev1@idias.com').first
    if(user)
	  user.roles.create(:name => 'Student')
    end
  end

  def self.down
    user = User.where(:email => 'dev1@idias.com').first
    if(user)
      role = user.roles.where(:name => 'Student').first
      if(role)
        role.destroy
      end
    end
  end
  
end
