require "script/lib/layout"

# Utility method for building paths
# It has been requested to put this in the Facets library

class String
  def / obj
    File.join(self, obj)
  end
end

namespace :test do

  %w(nitro raw og).each do |project|
  
    test_path = File.expand_path(project/"test")
  
    files = FileList[test_path/"**"/"*.rb"].exclude(/helper/)

    desc "Run tests for #{project.capitalize}"
    task project do
      SpecWrap.new(*files).run
    end

    # allow individual files to be run through rake, no desc added
    # to not blow up the rake -T output
    
    namespace project do
      files.each do |file|
        task_name = file.gsub(/\A#{Regexp.escape test_path}\/(.*)\.rb\z/,'\1').gsub(/\//,':')
        
        desc "Run test #{task_name} of #{project}"
        task task_name do
          SpecWrap.new(file).run
        end
      end
    end

  end

  desc "Run all tests"
  task :all => [:nitro, :raw, :og]

end

