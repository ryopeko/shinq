require 'rails/generators/named_base'
module Shinq
  module Generators
    class WorkerGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      def create_worker_file
        template 'worker.erb', File.join('app/workers', class_path, "#{file_name}.rb")
      end
    end
  end
end
