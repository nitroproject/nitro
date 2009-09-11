require "rubygems"

Gem::Specification.new do |s|
  s.name = "nitro"
  s.version = "0.50.0"
  s.date = Time.now.to_s
  s.author = "George K. Moschovitis"
  s.summary = "Everything you need to create Web 2.0 applications with Ruby and Javascript"
  s.description = <<-EOS
  Nitro provides everything you need to develop professional Web
  applications using Ruby and Javascript. Nitro redefines Rapid 
  Application Development by providing a clean, yet efficient API, 
  a layer of domain specific languages implemented on top of 
  Ruby and the most powerful and elegant object relational 
  mapping solution available everywhere. Nitro is Web 2.0 ready, 
  featuring excellent support for AJAX, XML, Syndication while 
  staying standards compliant.
  EOS

  s.homepage = "http://www.nitroproject.org"
  s.files = Dir.glob("{bin,lib,test,doc,proto}/**/*")
  s.files.concat %w{README INSTALL CHANGELOG}
  s.executables = %w{nitro}
  s.require_paths = %w{lib vendor}
  s.has_rdoc = true

  s.add_dependency("og", "= 0.50.0")
  s.add_dependency("raw", "= 0.50.0")
end
