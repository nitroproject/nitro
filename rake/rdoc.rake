
require "rake/rdoctask"

# We need this to make the RDoc tasks work.
# Otherwise HTML-style comments make the HTML generator raise.

module Kernel
  def handle_special_COMMENT(arg)
    arg.text.sub(/<!--(.*)-->/, "&lt;!--\\1--&gt;")
  end
end

namespace :rdoc do

  desc "Create RDOC documentation for all projects"
  task :all => [ :nitro, :raw, :og ]

#    puts "Building RDOC documentation for version #{version}"
#
#    `mkdir -p rdoc`
#
#    for pkg in packages
#      puts "...#{pkg}"
#      `cd #{pkg} && rdoc --main lib/README --op rdoc && cd .. && mv #{pkg}/rdoc rdoc/#{pkg}`
#    end
#  end

  %w{ nitro raw og }.each do |package|
    desc "Generate documentation for #{package.capitalize}"
    Rake::RDocTask.new(package) do |rdoc|
      rdoc.rdoc_dir = "rdoc/#{package}"
      rdoc.main     = "#{package}/README"
      rdoc.title    = "#{package.capitalize} RDoc | Nitro Framework"

      rdoc.options << "--line-numbers" 
      rdoc.options << "--inline-source"

      rdoc.rdoc_files.include("#{package}/README", "#{package}/lib/**/*.rb")
    end
  end

  desc "Cleanup RDOC documentation files"
  task :clean do
    `rm -rf rdoc`
  end

end
