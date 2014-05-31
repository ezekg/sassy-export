require './lib/SassyExport'

Gem::Specification.new do |s|
  # Release Specific Information
  s.version = SassyExport::VERSION
  s.date = SassyExport::DATE

  # Gem Details
  s.name = "SassyExport"
  s.rubyforge_project = "SassyExport"
  s.licenses = ['MIT']
  s.authors = ["Ezekiel Gabrielse"]
  s.email = ["ezekg@yahoo.com"]
  s.homepage = "https://github.com/ezekg/SassyExport/"

  # Project Description
  s.summary = %q{SassyExport is a lightweight plugin for SassyJSON that allows you to export an encoded Sass map into an external JSON file.}
  s.description = %q{SassyExport allows you to export a Sass map into an external JSON file.}

  # Library Files
  s.files += Dir.glob("lib/**/*.*")

  # Sass Files
  s.files += Dir.glob("stylesheets/**/*.*")

  # Template Files
  # s.files += Dir.glob("templates/**/*.*")

  # Other files
  s.files += ["LICENSE", "README.md"]

  # Gem Bookkeeping
  s.required_rubygems_version = ">= 1.3.6"
  s.rubygems_version = %q{1.3.6}

  # Gems Dependencies
  s.add_dependency("SassyJSON", [">=1.1.7"])

end