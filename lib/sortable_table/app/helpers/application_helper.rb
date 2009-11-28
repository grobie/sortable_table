module SortableTable
  module App
    module Helpers
      module ApplicationHelper
      
        def self.included(base)
          base.class_eval do
            include InstanceMethods
          end
        end
        
        module InstanceMethods
          def sortable_table_header(opts = {})
            raise ArgumentError if opts[:sort].nil?
            content_tag :th, 
              sort_link_to(opts[:sort], opts[:name], opts),
              :class => sortable_table_header_classes(opts),
              :colspan => opts[:colspan]
          end
          
          def sort_link_to(sort, name = nil, opts = {})
            opts.merge!(:sort => sort, :name => name)
            anchor = opts[:anchor].blank? ? "" : "##{opts[:anchor]}"
            link_to(sortable_table_title(opts),
              sortable_url(opts.merge(:sort => sort)) + anchor, 
              :title => opts[:title])
          end

          def sortable_table_header_classes(opts)
            class_names = []
            class_names << sortable_table_header_class(opts) 
            class_names << opts[:class]
            class_names.compact.blank? ? nil : class_names.compact.join(" ")
          end
          
          def sortable_table_header_class(opts)
            if re_sort?(opts) || sorting_default?(opts)
              sortable_table_direction
            end
          end
          
          def sortable_table_title(opts)
            text = opts[:name] || opts[:sort].to_s.titleize
            if re_sort?(opts) || sorting_default?(opts)
              text + (params[:order] == "ascending" ? " ▲" : " ▼")
            else
              text
            end
          end

          def sorting_default?(opts)
            params[:sort].nil? && opts[:sort].to_s == default_sort_column
          end
          
          def re_sort?(opts)
            params[:sort] == opts[:sort].to_s
          end
          
          def reverse_order(order)
            order == 'ascending' ? 'descending' : 'ascending'
          end
          
          def sortable_url(opts)
            url_for(params.merge(:sort => opts[:sort], :order => link_sort_order(opts), :page => 1))
          end
          
          def link_sort_order(opts)
            if re_sort? opts
              reverse_order params[:order]
            else
              sortable_table_direction
            end
          end
        end
        
      end
    end
  end
end
