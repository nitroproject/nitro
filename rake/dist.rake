# TODO : (ab) Consider to use Hoe for this kind of stuff

namespace :dist do

  desc "Create gem and zip distributions for all projects"
  task :all do
    version = '0.50.0' 

    gem_packages = %w{ nitro raw og }
#   zip_packages = %w{ examples }

    puts "Building packages for version #{version}"

    `mkdir -p dist`

    for pkg in gem_packages
      puts "...#{pkg}"
      `tar cvfz dist/#{pkg}-#{version}.tgz #{pkg}`
      `zip -r dist/#{pkg}-#{version}.zip #{pkg}/*`
      `cd #{pkg} && gem build #{pkg}.gemspec && cd .. && mv #{pkg}/*.gem dist/.`
    end
=begin
    for pkg in zip_packages
      puts "...#{pkg}"
      `tar cvfz dist/#{pkg}-#{version}.tgz #{pkg}`
      `zip -r dist/#{pkg}-#{version}.zip #{pkg}/*`
    end
=end
  end

  desc "Push gems to nitroproject.org"
  task :push do
    `scp dist/*.gem root@reizu.com:www/nitroproject-files/gems/.`
  end
  
  desc "Cleanup distribution files"
  task :clean do
    `rm -rf dist`
  end

end
