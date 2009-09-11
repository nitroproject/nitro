# = Nitro 
#
# Copyright (c) 2004-2007, George Moschovitis (http://www.gmosx.com)
#
# Nitro (http://www.nitroproject.org) is copyrighted free 
# software created and maintained by George Moschovitis 
# (mailto:george.moschovitis@gmail.com) and released under the 
# standard BSD Licence. For details consult the file doc/LICENCE.

require "facets"
require "facets/settings"
require "facets/logger"

require "og/global_logger"

module Nitro
  # The version of Nitro.

  Version = "0.50.0"

  # Library path.

  LibPath = File.join(File.dirname(__FILE__), "..")

  # The path to the prototype application.

  setting :proto_path, :default => File.join(LibPath, "..", "proto"), :doc => "The path to the prototype application"
end

#--
# gmosx: leave them here.
#++

$STATIC_ASPECTS = true

require "og/aspects"

require "raw"

module Nitro

  include Raw
# include Og if defined? Og

  class << self

    # The execution mode, typical modes include :debug, 
    # :stage, :live. 
    #
    # [:debug]
    #    useful when debugging, extra debug information
    #    is emmited, actions, templates and shaders are
    #    reloaded, etc. The execution speed of the application
    #    is impaired.
    #
    # [:stage]
    #    test the application with live parameters 
    #    (typically on a staging server).
    #
    #  [:live]
    #    use the parameters for the live (production)
    #    server. Optimized for speed.
    #
    # Tries to set the default value from the NITRO_MODE
    # environment variable.

    attr_accessor :mode

    # A helper method to start a Nitro application.

    def start(controller = Controller)
      @application = Application.new
      @application.dispatcher = Dispatcher.new(controller)
      @application.start
    end
    alias_method :run, :start    

    # Are we running in live mode ?

    def live?
      @mode == :live
    end
    alias_method :production?, :live?    

  end

end

require "nitro/autoload"
require "nitro/application"
