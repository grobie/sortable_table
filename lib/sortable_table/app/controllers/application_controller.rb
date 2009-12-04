module SortableTable
  module App
    module Controllers
      module ApplicationController

        def self.included(base)
          base.class_eval do
            include InstanceMethods
            extend ClassMethods
          end
        end

        module ClassMethods
          def sortable_attributes(*args)
            mappings           = pop_hash_from_list(args)
            acceptable_columns = join_array_and_hash_values(args, mappings)
            define_sort_order(acceptable_columns, mappings)
          end

          def pop_hash_from_list(args)
            if args.last.is_a?(Hash)
              args.pop
            else
              {}
            end
          end

          def join_array_and_hash_values(array, hash)
            array.collect { |each| each.to_s } +
              hash.keys.collect { |each| each.to_s }
          end

          def define_sort_order(acceptable_columns, mappings)
            define_method(:default_sort_column) do
              acceptable_columns.first
            end

            attr_accessor :sortable_table_direction
            
            define_method(:order) do
              column = params[:sort] || default_sort_column
              column = acceptable_columns.first unless acceptable_columns.include?(column)
              (mappings[column.to_sym] || column).dup
            end
            
            define_method(:sort_mode) do |default|
              direction = default_sort_direction(params[:order], default)
              self.sortable_table_direction = direction
              sql_sort_direction(direction).to_sym
            end

            define_method(:sort_order) do |*default|
              handle_compound_sorting order(), sort_mode(default.first).to_s
            end

            helper_method :sort_order, :default_sort_column, :sortable_table_direction
            hide_action :sort_order, :default_sort_column, :sortable_table_direction, :sortable_table_direction=
          end
        end

        module InstanceMethods
          protected

            def default_sort_direction(order, default)
              case
              when ! order.blank?                                 then normalize_direction(order)
              when default.is_a?(Hash) && default[:default]       then normalize_direction(default[:default])
              when default.is_a?(String) || default.is_a?(Symbol) then normalize_direction(default.to_s)
              else "descending"
              end
            end

            def sql_sort_direction(direction)
              case direction
              when "ascending",  "asc" then "asc"
              when "descending", "desc" then "desc"
              end
            end

            def normalize_direction(direction)
              case direction.to_s
              when "ascending", "asc" then "ascending"
              when "descending", "desc" then "descending"
              else raise RuntimeError.new("Direction must be ascending, asc, descending, or desc")
              end
            end

            def handle_compound_sorting(column, direction)
              if column.is_a?(Array)
                column.collect { |col| handle_compound_sorting(col, direction) }.join(',')
              else
                if match = column.match(/(.*)\s+reverse\s*$/)
                  "#{match[1]} #{'asc' == direction ?  'desc'  : 'asc'}"
                else
                  "#{column} #{direction}"
                end
              end
            end
        end
      end
    end
  end
end
