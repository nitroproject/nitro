desc 'Convert tabs to spaces and \r\n to \n'

task :tabs do
  LF = "\x0a"
  INCLUDE = "**/*"
  EXCLUDE =  
    %w(
       \.db$ 
       \.bin$ 
       \.gif$ 
       \.png$ 
       \.swf$ 
       \.jpg$ 
       \.gem$
       \.zip$
       \.tgz$
       darcs
      )

  Dir[INCLUDE].each do |filename|
    unless File.directory?(filename) || EXCLUDE.any? {|reg| /#{reg}/ === filename}
      orig = File.read(filename)
      conv = orig.gsub("\t", " "*2).gsub(/\r\n/, LF)
      if conv != orig
        puts "Modified #{filename}"
        File.open(filename, "wb") {|f| f << conv}
      end
    end
  end
end
