namespace :cleanup do

  desc "cleanup miscelanious files"

  task :misc do
    `rm bundle`
    `rm -rf dist`
    `rm og/test.db`
    `rm -rf og/fstest_db`
    `rm -rf og/test_db`
    `rm -rf examples/blog/cache`
    `rm examples/blog/blog.db`
    `rm -rf examples/blog/.temp`
    `rm examples/why_wiki/wiki.yml`
    `rm examples/tiny/public/image.png`
    `rm -rf examples/gallery/public/upload`
    `rm examples/gallery/data.db`
    `rm og/examples/test.db`
    `rm -rf og/kirbydb`
    `rm examples/blog/log/*log`
    `rm flare/flare.db`
    `rm spark/spark.db`
    `rm spark/db.dump`
    `rm examples/client/data.db`
    `rm -rf og/test/cache/`
    `rm og/data.db`
    `rm nitro/data.db`
    `rm -rf nitro/test/cache/`
    `rm -rf test`
    `rm data.db`
    
    `rm -rf dist`
    `rm -rf examples/blog/.temp`
    `rm -rf examples/blog/log`
    `rm -rf examples/hello/.temp`
    `rm -rf examples/hello/log`
  end

  desc "Cleanup rDoc directories"

  task :rdoc do
    `rm -rf og/rdoc`
    `rm -rf nitro/rdoc`
    `rm -rf gen/rdoc`
  end

  desc "Cleanup caches"

  task :cache do
    `rm -rf nitro/examples/blog/cache`
  end

  desc "Cleanup distribution dirs"

  task :dist do
    `rm -rf dist/`
    `rm -rf nitro/dist`
    `rm -rf og/dist`
  end

  desc "Perform all cleanup tasks"

  task :all => [:misc, :rdoc, :cache, :dist]

end
