# typed: false

require 'logger'
require 'sorbet-runtime'

# TODO: Make it typed somehow
module Logging
  extend T::Sig

  def self.included(base)
    class << base
      def logger
        @logger ||= Logger.new(STDOUT)
      end

      def logger=(logger)
        @logger = logger
      end
    end
  end

  sig { returns(Logger) }
  def logger
    self.class.logger
  end
end
