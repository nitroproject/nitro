# Require this file in your specs
#  require "script/lib/spec"

%w(og nitro raw).each do |project|
  base = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", project, "lib"))
  $:.unshift base.gsub(/^#{Dir.pwd}/, ".")
end

begin
  require "rubygems"
rescue LoadError => ex
  #drink it!
end

require "spec"
require "script/lib/in"

if Spec::VERSION::FULL_VERSION < "1.0.3 (r2035)"
  puts "please update rspec >= 1.0.3"
  exit 1
end
