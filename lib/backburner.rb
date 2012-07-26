require 'beanstalk-client'
require 'json'
require 'uri'
require 'timeout'
require 'backburner/version'
require 'backburner/helpers'
require 'backburner/configuration'
require 'backburner/logger'
require 'backburner/connection'
require 'backburner/performable'
require 'backburner/worker'
require 'backburner/queue'

module Backburner
  class << self

    # Enqueues a job to be performed with arguments
    # Backburner.enqueue NewsletterSender, self.id, user.id
    def enqueue(job_class, *args)
      Backburner::Worker.enqueue(job_class, args, {})
    end

    # Begins working on jobs enqueued with optional tubes specified
    # Backburner.work('newsletter_sender', 'test_job')
    def work(*tubes)
      Backburner::Worker.start(tubes)
    end

    # Yields a configuration block
    # Backburner.configure do |config|
    #  config.beanstalk_url = "beanstalk://..."
    # end
    def configure(&block)
      yield(configuration)
      configuration
    end

    # Returns the configuration options set for Backburner
    # Backburner.configuration.beanstalk_url => false
    def configuration
      @_configuration ||= Configuration.new
    end

    # Returns the queues that are processed by default if none are specified
    # default_queues << "foo"
    # default_queues => ["foo", "bar"]
    def default_queues
      configuration.default_queues
    end
  end
end