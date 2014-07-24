require "compass"
require "json"

extension_path = File.expand_path(File.join(File.dirname(__FILE__), ".."))
Compass::Frameworks.register('SassyExport', :path => extension_path)

# Version is a number. If a version contains alphas, it will be created as a prerelease version
# Date is in the form of YYYY-MM-DD
module SassyExport
  VERSION = "1.3.2"
  DATE = "2014-07-24"
end

# SassyExport : convert passed map to json and write to path/to/filename.json
# ----------------------------------------------------------------------------------------------------
# @param path [string] : directory path and filename
# @param map [map] : map to convert to json
# @param pretty [bool] : pretty print json
# @param debug [bool] : print debug string with path
# ----------------------------------------------------------------------------------------------------
# @return string | write json to path

module Sass::Script::Functions
    def SassyExport(path, map, pretty, debug)

        def opts(value)
            value.options = options
            value
        end

        # unquote strings
        def u(s)
            unquote(s)
        end

        # recursive parse to array
        def recurs_to_a(array)
            if array.is_a?(Array)
                array.map do | l |
                    if l.is_a?(Sass::Script::Value::Map)
                        # if map, recurse to hash
                        l = recurs_to_h(l)
                    elsif l.is_a?(Sass::Script::Value::List)
                        # if list, recurse to array
                        l = recurs_to_a(l)
                    elsif l.is_a?(Sass::Script::Value::Bool)
                        # convert to bool
                        l = l.to_bool
                    elsif l.is_a?(Sass::Script::Value::Number)
                        # if it's a unitless number, convert to ruby val
                        if l.unitless?
                            l = l.value
                        # else convert to string
                        else
                            l = u(l)
                        end
                    elsif l.is_a?(Sass::Script::Value::Color)
                        # get hex/rgba value for color
                        l = l.inspect
                    else
                        # convert to string
                        l = u(l)
                    end
                    l
                end
            else
                recurs_to_a(array.to_a)
            end
        end

        # recursive parse to hash
        def recurs_to_h(hash)
            if hash.is_a?(Hash)
                hash.inject({}) do | h, (k, v) |
                    if v.is_a?(Sass::Script::Value::Map)
                        h[u(k)] = recurs_to_h(v)
                    elsif v.is_a?(Sass::Script::Value::List)
                        h[u(k)] = recurs_to_a(v)
                    elsif v.is_a?(Sass::Script::Value::Bool)
                        h[u(k)] = v.to_bool
                    elsif v.is_a?(Sass::Script::Value::Number)
                        if v.unitless?
                            h[u(k)] = v.value
                        else
                            h[u(k)] = u(v)
                        end
                    elsif v.is_a?(Sass::Script::Value::Color)
                        h[u(k)] = v.inspect
                    else
                        h[u(k)] = u(v)
                    end
                    h
                end
            else
                recurs_to_h(hash.to_h)
            end
        end

        # assert types
        assert_type path, :String, :path
        assert_type map, :Map, :map
        assert_type pretty, :Bool, :pretty
        assert_type debug, :Bool, :debug

        # parse to bool
        pretty = pretty.to_bool
        debug = debug.to_bool

        # parse to string
        path = unquote(path).to_s

        # define root path up to current working directory
        root = Dir.pwd

        # define dir path
        dir_path = root
        dir_path += path

        # get filename
        filename = File.basename(dir_path, ".*")

        # get extension
        ext = File.extname(path)

        # normalize windows path
        dir_path = Sass::Util.pathname(dir_path)

        # check if directory exists, if not make directory
        dir = File.dirname(dir_path)

        unless File.exists?(dir)
            FileUtils.mkdir_p(dir)
            puts "Directory was not found. Created new directory: #{dir}"
        end

        # get map values
        map = opts(Sass::Script::Value::Map.new(map.value))

        # recursive convert map to hash
        hash = recurs_to_h(map)

        # convert hash to pretty json if pretty
        pretty ? json = JSON.pretty_generate(hash) : json = JSON.generate(hash)

        # if we're turning it straight to js put a variable name in front
        ext == '.js' ? json = "var " + filename + " = " + json : json = json

        # define flags
        flag = 'w'
        flag = 'wb' if Sass::Util.windows? && options[:unix_newlines]

        # open file [create new file if file does not exist], write string to root/path/to/filename.json
        File.open("#{dir_path}", flag) do |file|
            file.set_encoding(json.encoding) unless Sass::Util.ruby1_8?
            file.print(json)
        end

        # define message
        debug_msg = "#{ext == '.json' ? 'JSON' : 'JavaScript'} was successfully exported to #{dir_path}"

        # print path string if debug
        puts debug_msg if debug

        # return succcess string
        opts(Sass::Script::Value::String.new(debug_msg))
    end
    declare :SassyExport, [:path, :map, :pretty, :debug]
end
