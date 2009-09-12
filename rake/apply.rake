namespace :darcs do

  desc "Apply a patch bundle to the darcs repository"

  task :apply do
    bundle = ENV['BUNDLE'] || ENV['bundle'] || 'bundle'
    `darcs apply --verbose --reply=george.moschovitis@gmail.com --cc=nitro-repository@rubyforge.org #{bundle}`
  end

end
