require File.dirname(__FILE__) + '/../../test_helper'

class ApplicationHelperTest < HelperTestCase

  include ApplicationHelper
  
  context 'helper method' do
    setup do
      self.stubs(:default_sort_column).returns(:not_title)
      self.stubs(:sortable_table_direction).returns("ascending")
      self.stubs(:params).returns({ :controller => :jobs, :action => :index, :sort => nil, :order => nil })
    end
  
    context 'sort_link_to' do  
      context 'with no params[:sort] or params[:order]' do
        setup do
          @html = sort_link_to(:title, "the title")
        end
      
        should 'return a link' do
          assert @html.match(/<a[^>]*>the title<\/a>/)
        end
      end
      
      context 'with ascending params[:sort]' do
        setup do
          params[:sort] = "title"
          params[:order] = "ascending"
          @html = sort_link_to(:title)
        end
      
        should "append a triangle to the link text" do
          assert @html.include?('Title ▲')
        end
      end
      
      context 'with descending params[:sort]' do
        setup do
          params[:sort] = "title"
          params[:order] = "descending"
          @html = sort_link_to(:title)
        end
      
        should "append a triangle to the link text" do
          assert @html.include?('Title ▼')
        end
      end
    end
  
    context 'sortable_table_header' do
      should "raise an error without default param sort" do
        opts = { :name => 'name' }
        assert_raise(ArgumentError) do
          sortable_table_header opts
        end
      end

      should "not raise an error without default param name" do
        opts = { :sort => 'sort' }
        sortable_table_header opts
      end

      context 'with no params[:sort] or params[:order]' do
        setup do
          @html = sortable_table_header(:name  => 'Title', 
                                        :sort  => 'title', 
                                        :title => 'Sort by title')
        end

        should 'return a table header without a class attribute' do
          assert @html.include?('<th>')
        end
      end
    
      context 'with params[:class]' do
        setup do
          @html = sortable_table_header(:name  => 'Title', 
                                        :sort  => 'title', 
                                        :title => 'Sort by title', 
                                        :class => "hr_class")
        end
      
        should 'return a table header with a class attribute equal to the passed in class' do
          assert @html.include?('<th class="hr_class"')
        end
      end

      context "without an :anchor" do
        setup do
          @html = sortable_table_header(:name  => 'Title', 
                                        :sort  => 'title', 
                                        :title => 'Sort by title')
        end

        should 'return a link that contains a url with no anchor' do
          assert @html.match(/href="[^#]+?"/)
        end
      end

      context "with an :anchor" do
        setup do
          @html = sortable_table_header(:name   => 'Title', 
                                        :sort   => 'title', 
                                        :title  => 'Sort by title', 
                                        :anchor => 'search-results')
        end

        should 'return a link that contains a url with that anchor' do
          assert @html.match(/href="[^"]*?#search-results"/)
        end
      end

      %w( ascending descending ).each do |direction|
        context "as the default column with no options specified and a default of #{direction}" do
          setup do
            self.stubs(:default_sort_column).returns('title')
            self.stubs(:sortable_table_direction).returns(direction)
            @html = sortable_table_header(:name   => 'Title', 
                                          :sort   => 'title', 
                                          :title  => 'Sort by title', 
                                          :anchor => 'search-results')
          end

          should "return a header with an #{direction} class" do
            assert @html.match(/<th class="#{direction}">/)
          end
        end
      end
    end
  end
  
end
