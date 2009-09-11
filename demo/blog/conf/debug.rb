require "raw/mailer"

def setup_nitro
  Raw::Caching.enabled = false 
  Raw::Template.strip_xml_comments = false 
  Raw::Session.secret = "myblogsecret"

  Nitro::Mailer.delivery_method = :dump
end

def setup_og
  Og.create_schema = true 
  Og.use_uuid_primary_keys = true
  Og.start(
#   :destroy => true,
    :name => "blog",
    :adapter => :mysql,
    :user => "root",
    :password => ENV["DB_PASSWORD"], # SET your password here!
    :evolve_schema => :full 
  )

  init_og
end

def setup_app(app)
  app.port = 9000
  app.adapter = :webrick
end

def setup(app)
  setup_og
  setup_nitro
  setup_app(app)
end

def init_og
  return unless Category.all.empty?

  info "Initializing Database"
  
  Category.create_with(:title => "Software")
  Category.create_with(:title => "Hardware")
  Category.create_with(:title => "Design")
  Category.create_with(:title => "Miscellanea")
  
  post = Post.new.assign_with(
    :title => "Hello",
    :body => "Welcome to this blog. This is the canonical Nitro example. Consult the source code of this web application for valuable Nitro and Og related techniques.",
    :author => "George Moschovitis"
  )
  post.category = Category.find_by_title("Miscellanea")
  post.save
end
