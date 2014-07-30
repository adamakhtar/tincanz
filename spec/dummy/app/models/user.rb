class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable

  acts_as_tincanz_user

  def can_manage_tincanz?
    !!self.admin
  end

  def self.tincanz_admin
    where(admin: true)
  end
end
