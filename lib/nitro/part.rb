#require "facets/class/descendents"

module Nitro

# A part is a module of reusable functionality encapsulated as 
# a mini site/app. You can require (include) multiple parts in 
# your application. A part is in essence a high level component.
#
# The directory structure of a part mirrors the structure 
# of a typicall web application. By conventions we put the
# main directories of parts in a root directory called 'part'.
#
# Let's demonstrate the above with an example. Two parts are
# defined here. A user management part (users) and a CMS 
# (content). A typical dir structure goes like this ($ is a 
# directory in the load path, this means you can put parts in 
# multiple places as long as the are in the load path):
#
# $/part # parts will be stored here.
#
# $/part/users.rb # helper file used to 'require' the part.
# $/part/users/public/
# $/part/users/controller.rb
# $/part/users/controller/xml.rb
# $/part/users/model/user.rb
# $/part/users/model/acl.rb
# $/part/users/template/login.xhtml
# $/part/users/template/form.xinc
# $/part/users/run.rb # starts an 'example' application for this part.
#
# $/part/content.rb
# $/part/content/controller.rb
# $/part/content/model.rb
# ...
#
# Given this direcotry structure you can 'require' a part 
# like this:
#
# Part.require "users"
# Part.require "content"
#
# The helper files (for example the file part/users.rb) typically
# require the part files needed by default.
#
# The 'example' application start files (for example part/users/run.rb)
# are optional. If present, they start a small application that
# demonstrates the usage of the part. In the example app, the main
# part controller is mounted at the root ('/'). Typically, in
# your own applications, you will mount the controller as needed,
# (for example: 'users' => UsersController, 
# 'blog' => 'ContentController') 
#
# The files that reside in the public directory are typically
# copied by a code generator to your application public dir.
#
# Part controllers setup the template root stack to lookup 
# templates in their local template dir (for example part/users/template)
# if a template is not found in the applications normal template
# root. In essence, by requiring a part a target application,
# 'inherits' its templates. If you want to customize (override)
# one template, just place a template with the same name in the
# respective directory in the application template root.
#
#--
# TODO:
#
# * add support for autoload
# * add support for install/uninstall
#++

class Part

  # Perform part initialization, just before the server is 
  # started. Override this in your parts.

  def initialize(server)
  end

  # Perform part finalization.

  def finalize(server)
  end

  # Perform part initialization when the part is installed,
  # ie you add this in your application. Here comes one time
  # initialization  code.

  def install
  end

  # Perform part cleanup when you want to remove the part
  # from your application.

  def uninstall
  end
  alias_method :cleanup, :uninstall

  class << self
    attr_accessor :active_parts

    #alias_method :require_without_part, :require

    # Require (include) a part in the current application.
    #--
    # TODO Should this be more specific about the app dir?
    #++
    def require(name)
      debug "Requiring part '#{name}'." if $DBG
      Kernel.require "./part/" + name
    end

    # Call the initialization code of all parts. Typically
    # called just before the server starts.

    def setup(server)
      @active_parts = []
      for klass in self.descendents
        @active_parts << klass.new(server)        
      end
    end

    # Call the finalization code of all parts. Typically
    # called just when the server stops.

    def finalize(server)
      for part in @active_parts
        part.finalize(server)
      end
    end

  end

end

end
