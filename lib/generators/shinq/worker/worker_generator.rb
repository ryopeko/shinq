require 'rails/generators/named_base'
require 'rails/generators/model_helpers'
require 'rails/generators/active_record/migration'

module Shinq
  module Generators
    class WorkerGenerator < ::Rails::Generators::NamedBase
      include ::Rails::Generators::ModelHelpers
      include ::Rails::Generators::Migration
      include ::ActiveRecord::Generators::Migration

      argument :attributes, :type => :array, :default => [], :banner => "field[:type][:index] field[:type][:index]"

      check_class_collision

      class_option :migration,  :type => :boolean
      class_option :parent,     :type => :string, :desc => "The parent class for the generated model"

      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      def create_migration_file
        migration_template 'create_table_migration.erb', "db/migrate/create_#{table_name}.rb"
      end

      def create_worker_file
        template 'worker.erb', File.join('app/workers', class_path, "#{file_name}.rb")
      end
    end
  end
end
