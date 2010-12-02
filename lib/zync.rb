require 'eventmachine'
require 'rack'
require 'active_support/core_ext'

module Zync
  autoload :Application,  'zync/application'
  autoload :Logger,       'zync/logger'
  autoload :Logging,      'zync/logging'
  autoload :Routing,      'zync/routing'
  autoload :Util,         'zync/util'

  autoload :Controller,   'zync/controller'
  autoload :Callbacks,    'zync/callbacks'
  autoload :Body,         'zync/body'

  module Test
    autoload :ControllerHelper, 'zync/test/controller_helper'
  end

  class << self
    attr_accessor :application, :settings
    attr_writer :logger

    def config
      application && application.config
    end
    
    def logger
      # Use synchronous Logger by default
      @logger ||= ::Logger.new(File.join(Zync.root, 'log', "#{Zync.env}.log"))
    end

    def root
      # application && application.config.root
      ZYNC_ROOT
    end

    def env
      @env ||= ENV['RACK_ENV'] || 'development'
    end
  end
end
