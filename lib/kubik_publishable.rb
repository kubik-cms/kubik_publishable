# frozen_string_literal: true

require "kubik_publishable/configuration"

module KubikPublishable
  class Error < StandardError; end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def config
      configuration
    end

    def configure
      yield(configuration)
    end
  end

  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace KubikPublishable

      config.autoload_paths += Dir["#{root}/app/jobs"]
    end
  end
end

module Kubik
  require "kubik/publishable"
  require "kubik/publishable_admin_action"
  require "kubik/html_lint"
  require "kubik/html_quality"
  require "kubik/html_quality_checkable"
  require "kubik/html_quality_admin_action"
end
