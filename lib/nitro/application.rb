require "fileutils"

require "nitro/application/command_options"

module Nitro

# A Nitro application. This class orchestrates different
# components provided by the Nitro framework.

class Application

  # The name of the Server.

  attr_accessor :name

  # General options.

  attr_accessor :options

  # The listening address.

  attr_accessor :address

  # The listening port

  attr_accessor :port

  # The listening port offset, used in cluster scenarios.

  attr_accessor :port_offset

  # Run as daemon?

  attr_accessor :daemon

  # The dispatcher.

  attr_accessor :dispatcher

  # The adapter used to interface with the front web servers.

  attr_accessor :adapter

  # The compiler generates action methods for the controllers.

  attr_accessor :compiler

  # The session store.

  attr_accessor :session_store
  alias_method :sessions, :session_store

  # The public directory. All files that are placed here a
  # publicly accessible through the webserver.

  attr_accessor :public_dir

  # The temporary files dir. Put all your temporal files here
  # to keep the directory structure clean.

  attr_accessor :temp_dir

  # Handle static files? Set to true in live mode to avoid a
  # nasty bug: when caching is enabled and the index method
  # accepts parameters, static files may get corrupted. Think
  # something better.

  attr_accessor :handle_static_files

  # Options passed to nitro from the command line.

  attr_accessor :command_options

  def initialize(name = "Nitro Application", options = {})
    @name = name
    @options = options
    @address = "0.0.0.0"
    @port = 9000
    @port_offset = 0
    @daemon = false
    @compiler = Raw::Compiler.new(self)
    @adapter = :webrick
    @dispatcher = Raw::Dispatcher.new
    @public_dir = File.expand_path("public")
    @temp_dir = File.expand_path(".temp")
    @handle_static_files = true

    @command_options = Console::Arguments.new(ARGV).options

    # unelegant but will do the job.

    $nitro_current_application = self
  end

  # Return the adapter of this server. If necessary resolves
  # the adapter.

  def adapter
    if @adapter.is_a? Symbol
      require "raw/adapter/" + @adapter.to_s
      @adapter = constant("Raw::#{@adapter.to_s.camelize}Adapter").new
    end

    return @adapter
  end

  # Start the application.

  def start
    ensure_support_directories()
    configure()

    Global.setup
    Part.setup(self)

    require "raw/context/session/cookie"
    @session_store ||= Raw::CookieSessionStore.new

    if dispatcher.router
      for path, c in dispatcher.controllers
        dispatcher.router.add_rules_from_annotations(c)
      end
    end

    if defined?(:Og) and Og.respond_to?(:initialized?) and Og.initialized?
      # THINK: don't allways force this.
      require "raw/model/enchant"
      for m in Og.manager.models
        m.send(:include, Enchant)
      end
    end

    Aspects.setup

    @port += @port_offset

    info "Starting #{@adapter.to_s.capitalize} server in #{Nitro.mode} mode, listening at #@address:#@port"

    run_as_daemon if @daemon

    adapter.start(self)
  end

  # Stop the application.

  def stop
    Part.finalize(self)
    adapter.stop()
  end

  # Read configuration options from the command line arguments
  # (ARGV).

  def read_options
    #puts "applicaiton command options: #{command_options.inspect}" if ENV['NITRO_DEBUG']
    CommandOptions.new(self).set(command_options)
  end

  #   check_point :read_options do
  #     puts command_options
  #   end

  #def option_missing(opt, arg=nil)
  #  # drink it?
  #end

  # Read configuration options from the environment (ENV).

  def read_environment
    Nitro.mode ||= ENV.fetch("NITRO_MODE", :debug).to_sym
    @force_adapter = ENV["NITRO_ADAPTER"]
  end

  # Read configuration options from the configuration file
# TODO This load error too nice.
  def read_configuration_file
    conf_file = "conf/" + Nitro.mode.to_s
    full_conf_file = File.expand_path(conf_file)
    require(full_conf_file)  # or load ???
    setup(self)
  #rescue LoadError => ex
  #  error "Cannot find configuration file '#{full_conf_file}'"
  rescue => ex
    error pp_exception(ex)
    exit
  end

  # Apply some default settings for the selected
  # execution mode and then apply the application specific
  # confuguration settings.

  def configure
    read_options()
    read_environment()

    # Some reasonable defaults.

    case Nitro.mode
    when :debug, :stage
      $DBG = true
      @compiler.reloader.start(3)
      Raw::Caching.enabled = false
    else
      # Enable the reloading even on live apps by default.
      # But have a longer thread sleep time. If you really
      # need sligthly faster dispatching disable reloading
      # (don't start the reloader).

      @compiler.reloader.start(2 * 60)

      # Timestamp log entries in live mode.

      Logger.get.setup_format do |severity, timestamp, progname, msg|
        Logger::DETAILED_FORMAT % [timestamp.strftime("%d/%m %H:%M:%S"), severity, msg]
      end
    end

    read_configuration_file()

    # Force the adapter defined in the environment.

    @adapter = @force_adapter.to_sym if @force_adapter
  end

  # Convienience helper.
  #--
  # FIXME: something more elegant is needed here.
  #++

  def self.current
    $nitro_current_application
  end

private

  # Make sure some required directories are in place.

  def ensure_support_directories
    FileUtils.mkdir_p("log") # TODO: move this check to the Logger.
    FileUtils.mkdir_p(".temp")
  end

  # Run the application as a daemon.

  def run_as_daemon
    require "facets/daemonize"

    pwd = Dir.pwd

    daemonize()

    # Restore the original pwd (daemonize cd's to '/').

    Dir.chdir(pwd)

    # Save a process sentinel file.

    FileUtils.touch(File.join(".temp", "a#{Process.pid}.pid"))

    # Set the logger to a file (daemonize closes the std
    # streams).

    Logger.replace(Logger.new("log/app.log"))
  end

end

end
