# require "#{File.dirname(__FILE__)}/../../script/glycerin"

require "nitro"; include Nitro

class HelloWorld
  def index
    print "Hello World"
  end

  def hello(firstname, lastname)
    print "Hello #{firstname} #{lastname}!"
  end

  # An alternative version.

  def another
    "This works too"
  end
end

Nitro.start(HelloWorld)
