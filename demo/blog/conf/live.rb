require "raw/mailer"

def setup_nitro
  Raw::Caching.enabled = true
  Raw::Template.strip_xml_comments = true
  Raw::Session.secret = "myblogsecret"
end

def setup_og
  Og.create_schema = false
  Og.use_uuid_primary_keys = true
  Og.start(
    :name => "blog",
    :adapter => :mysql,
    :user => "root",
    :password => "mypassword",
    :evolve_schema => false
  )
end

def setup_app(app)
  app.port = 9000
  app.adapter = :mongrel
  app.handle_static_files = false
end

def setup(app)
  setup_og()
  setup_nitro()
  setup_app(app)
end
