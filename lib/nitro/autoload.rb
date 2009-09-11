#--
# Autoload core Nitro classes as needed. Potentially minimizes
# startup time and memory footprint, allows for cleaner source
# files, and makes it easier to move files around.
#++

if $DBG || defined?(Library)

  require "nitro/part"

else

  Nitro.autoload :Part, "nitro/part"

end
