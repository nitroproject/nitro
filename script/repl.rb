#!/usr/bin/env ruby

# Perform replacements in directory of files.
#
# Example:
#
# repl Dig Link
#
# replaces every occurance of Dig with Link

require 'facets/file/write'

class File
  
  class << self
    
    # Perform a text replacement in the contents of the
    # file.
    
    def gsub!(filename, regexp, value)
      str = File.read(filename)
      if str.gsub!(regexp, value)
        File.write(filename, str)
        return str
      end
    end
    alias_method :gsub, :gsub!
    
    #--
    # Under construction.
    #++
    
    def filter(filename, &blk)
      str = File.read(filename)
      yield(str)
    end
  
  end
  
end

def ignore?(filename)
  File.directory?(filename) or filename =~ /\.db$/ or 
      filename =~ /\.bin$/ or filename =~ /gif$/ or 
      filename =~ /png$/ or filename =~ /swf$/ or 
      filename =~ /jpg$/ or filename =~ /darcs/
end

if ARGV.size < 2
  puts 'Usage: script/repl.rb regexp value'
  exit
end

Dir['**/*'].each do |filename|
  unless ignore? filename
    if File.gsub(filename, /#{ARGV[0]}/, ARGV[1])
      puts "Changing #{filename}!"
    end
  end
end
