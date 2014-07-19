module Tincanz
  class AdminManagePolicy
    def initialize(user)
      @user = user
    end

    def access?
      @user.can_manage_tincanz?
    end
  end
end