# SassyExport is a lightweight plugin for SassyJSON
# ----------------------------------------------------------------------------------------------------
# @online https://github.com/HugoGiraudel/SassyJSON
# ----------------------------------------------------------------------------------------------------

require "SassyJSON"

# Version is a number. If a version contains alphas, it will be created as a prerelease version
# Date is in the form of YYYY-MM-DD
# ----------------------------------------------------------------------------------------------------

module SassyExport
  VERSION = "1.0.0"
  DATE = "2014-05-31"
end

# SassyJSON : write passed json string to path/to/filename
# ----------------------------------------------------------------------------------------------------
# @param path [string] : directory path to write string
# @param filename [string] : file name to write to path
# @param string [string] : json to write to filename
# ----------------------------------------------------------------------------------------------------
# @return string | write filename to path

module Sass::Script::Functions
    def SassyJSON_export(path, filename, string)
        # define root path up to current folder
        root = File.dirname(options[:filename] || ".")
        # open file [create new file if file does not exist], write $string to $root/$path/$filename
        File.open("#{root}/#{path}/#{filename}.json", "w") { |f| f.write(string) }
        # return string for use in css
        return string
    end
end