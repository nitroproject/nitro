# Adds the current darcs repo to the require path.
# Useful when playing with a development version
# of the source code.

unless defined? REPO_ROOT
  REPO_ROOT = File.join(File.dirname(File.expand_path(__FILE__)), "..", "..")
end

for project in %w{raw nitro og}
  $:.unshift(File.join(REPO_ROOT, project, "lib"))
end

# For Parts
$:.unshift(File.join(REPO_ROOT, "nitro", "lib", "nitro"))
