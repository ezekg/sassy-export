lib = File.expand_path "../lib/", __FILE__
$:.unshift lib unless $:.include? lib

require "sassy-export"

Gem::Specification.new do |s|
  s.version = SassyExport::VERSION

  s.name        = "sassy-export"
  s.summary     = "Sassy Export allows you to export a Sass map into an external JSON file."
  s.description = "Sassy Export is a lightweight Sass extension that allows you to export an encoded Sass map into an external JSON file."
  s.homepage    = "https://github.com/ezekg/sassy-export/"
  s.authors     = ["Ezekiel Gabrielse"]
  s.email       = ["ezekg@yahoo.com"]
  s.licenses    = ["MIT"]

  s.files += Dir.glob "lib/**/*.*"
  s.files += Dir.glob "stylesheets/**/*.*"
  s.files += ["README.md"]

  s.require_paths = ["lib", "stylesheets"]

  s.add_development_dependency "sass", "~> 3.3"
  s.add_development_dependency "json", "~> 1.8"
end
