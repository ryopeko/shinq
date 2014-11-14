require 'shinq/active_job/queue_adapters/shinq_adapter'

module Shinq
  class Rails < ::Rails::Engine
    initializer :shinq do
      Shinq::Rails.rails_bootstrap
    end

    def self.rails_bootstrap
      Shinq.configuration.db_config = ActiveRecord::Base.configurations
      Shinq.configuration.default_db = ::Rails.env
      Shinq.logger = ::Rails.logger
    end
  end
end
