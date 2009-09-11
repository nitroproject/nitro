#!/usr/bin/env ruby

require "drb"
require "optparse"
require "fileutils"

require "facets/synchash"

require "opod/memory"

module Nitro

# A Drb server, typically used to host the application caches
# (sessions, application scoped variables, og cache, fragment
# cache, etc).
#
# Example:
#
#   require 'nitro/server/drb
#
#   class MyDrbServer < Nitro::DrbServer
#     def setup_drb_objects
#       ...
#     end
#   end
#
#   MyDrbServer.start
#--
# FIXME: should probably move to another directory (scripts?)
# TODO: Add some debuging support (overload synchash).
# TODO: Implement MemcacheServer.
# TODO: Better start/stop functionality.
#++

class DrbServer

  # Parse the command line arguments.
  
  def parse_options
    parser = OptionParser.new do |opts|
      opts.banner = "Usage: #$0 [options]"
      opts.separator ''
      opts.separator 'Specific options:'

      opts.on('-D', '--debug', 'Run in debug mode.') do |p|
        @debug = true
      end

      opts.on('-d', '--daemon', 'Run as daemon.') do |p|
        @daemon = true
      end

      opts.on_tail('-h', '--help', 'Show this message.') do
        puts opts
        exit
      end
    end

    begin
      parser.parse!(ARGV)
    rescue OptionParser::InvalidOption
      puts 'Invalid option, pass the --help parameter to get help!' 
      exit
    end
  end

  # Override in your application to setup your custom objects.
  # The default implementation only creates a session store.
  
  def setup_drb_objects
    require 'nitro/session/drb'
    @session_cache = SyncHash.new 
    DRb.start_service("druby://#{Session.cache_address}:#{Session.cache_port}", @session_cache)    
    puts "Drb session cache at druby://#{Session.cache_address}:#{Session.cache_port}."
  end
  
  def setup_drb
    setup_drb_objects()
    DRb.thread.join    
  end

  # Start the DRb server.
  #--
  # TODO: refactor with runner code.
  #++
      
  def start
    parse_options

    if @daemon
      require "facets/daemonize"

      daemonize()

      # Save a process sentinel file.
      FileUtils.touch(File.join(".temp","d#{Process.pid}.pid"))
    end
    setup_drb()
  end
  alias_method :start!, :start

  # A helper method to start the DRb server.
    
  def self.start
    self.new.start
  end
  
end

DrbServer.start if __FILE__ == $0

end

