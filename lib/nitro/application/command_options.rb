require "facets/command"

module Nitro

# Parse the command line arguments for this application.

class Application
  class CommandOptions

    attr :application

    # The application this parser configures.
    
    def initialize(application)
      @application = application
    end

    # Do nothing.

    def set(options)
      options.each do |k, v|
        k = k.gsub("-", "_")
        send("#{k}=", v) rescue nil
      end
    end

    # The name of this application.

    def app=(name)
    end

    # Add this offest to the listening port. Useful in cluster
    # configurations.

    def port_offset=(offset)
      @application.port_offset = offset.to_i
    end
    alias_method :po=, :port_offset=

    # Override the adapter.

    def adapter=(adapter)
      @application.adapter = adapter.to_sym
    end
    alias_method :a=, :adapter=

    # Run with Webrick adapter.

    def webrick=(_)
      @application.adapter = :webrick
    end

    # Run with Mongrel adapter.

    def mongrel=(_)
      @application.adapter = :mongrel
    end

    # Run with Swiftiply adapter. All app instances listen to
    # the same port.

    def swiftiply=(_)
      @application.adapter = :mongrel
      @application.port_offset = 0
    end

    # Override the execution mode.

    def mode=(mode)
      Nitro.mode = mode.to_sym
    end

    # Run in debug mode. Useful for development.

    def debug=(_)
      Nitro.mode = :debug
    end
    alias_method :devel=, :debug=

    # Run in stage mode. Useful for final testing before going
    # live.

    def stage=(_)
      Nitro.mode = :stage
    end
    alias_method :staging=, :stage=

    # Run in live mode. Used in the production environment.

    def live=(_)
      Nitro.mode = :live
    end
    alias_method :production=, :live=
    alias_method :l=, :live=

    # Run the application as a daemon.

    def daemon=(_)
      @application.daemon = true
    end
    alias_method :d=, :daemon=

    # Record a user-server interaction session. Usefull for
    # regression testing.

    def record=(filename)
      @application.adapter = :webrick
      require "raw/adapter/webrick"
      require "raw/adapter/webrick/vcr"
      $record_session_filename = filename
    end

    # Playback a previously recorded user-server interaction
    # session. Useful for regression testing.

    def playback=(filename)
      @application.adapter = :webrick
      require "raw/adapter/webrick"
      require "raw/adapter/webrick/vcr"
      $playback_session_filename = filename
    end

    # Install a part (typically copy needed files to the application
    # directory, setup the database, etc).

    def part_install=(part)
      require "nitro/part/#{part.underscore}"
      print "Installing '#{part}' part, press a key to confim.."
      STDIN.getc
      eval %{#{part}Part.install("#{File.expand_path('.')}")}
      exit
    end
    alias_method :pinstall=, :part_install=

    # Uninstall a part and perform cleanup operations.

    def part_uninstall=(part)
      require "nitro/part/#{part.underscore}"
      print "Uninstalling '#{part}' part, press a key to confim.."
      STDIN.getc
      eval %{#{part}Part.uninstall("#{File.expand_path('.')}")}
      exit
    end
    alias_method :puninstall=, :part_uninstall=

  end
end

end
