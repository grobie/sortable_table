class Admin::UsersController < ApplicationController

  sortable_attributes({:name => "users.name",
                       :age  => "users.age reverse",
                       :email => "users.email",
                       :group => "groups.name",
                       :age_and_name => ["age", "users.name"]})

  def index
    @users = User.find :all, :include => :group, :order => sort_order
  end

end
