require "sortable_table"

ActionController::Base.send(:include, SortableTable::App::Controllers::ApplicationController)
ActionView::Base.send(:include, SortableTable::App::Helpers::ApplicationHelper)