require "sass"
require "json"
require "sassy-export/version"
require "sassy-export/exporter"

base_directory = File.expand_path File.join(File.dirname(__FILE__), "..")
sassy_export_stylesheets_path = File.join base_directory, "stylesheets"

if (defined? Compass)
  Compass::Frameworks.register "sassy-export",
    :path => base_directory
else
  ENV["SASS_PATH"] = [ENV["SASS_PATH"], sassy_export_stylesheets_path]
    .compact.join File::PATH_SEPARATOR
end

module SassyExport
  Sass::Script::Functions.send :include, SassyExport::Exporter
end
