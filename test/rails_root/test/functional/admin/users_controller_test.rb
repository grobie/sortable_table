require File.dirname(__FILE__) + '/../../test_helper'

class Admin::UsersControllerTest < ActionController::TestCase

  context "enough Users to sort" do
    setup do
      5.times { Factory :user }
    end

    should_sort_by_attributes :name, :email

    should_sort_by :group => 'groups.name' do |user|
      user.group.name
    end

    should_sort_by :age_and_name => ["age", "users.name"] do |user|
      "#{user.age}#{user.name}"
    end

    should "sort 'reverse' attributes in reverse by default" do
      get :index, :sort => 'age'
      assert_equal User.all.sort_by(&:age), assigns(:users)
    end

    should "sort 'reverse' attributes in reverse of specified params[:order]" do
      get :index, :sort => 'age', :order => 'ascending'
      assert_equal User.all.sort_by(&:age).reverse, assigns(:users)
    end

    should "not sort by unmapped key name when bogus sort is given" do
      assert_nothing_raised do
        get :index, :sort => 'invalid'
      end
    end

    context "GET to #index" do
      setup { get :index }
      should_display_sortable_table_header_for :name, :email, :age, :group
    end
  end

end
