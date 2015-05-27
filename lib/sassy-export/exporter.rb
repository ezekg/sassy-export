module SassyExport
  module Exporter
    BLACK   = "\e[30m"
    RED     = "\e[31m"
    GREEN   = "\e[32m"
    YELLOW  = "\e[33m"
    BLUE    = "\e[34m"
    MAGENTA = "\e[35m"
    CYAN    = "\e[36m"
    WHITE   = "\e[37m"

    def self.declare(*args)
      Sass::Script::Functions.declare *args
    end

    def export(path, map, pretty, debug, use_env)
      assert_type path, :String, :path
      assert_type map, :Map, :map
      assert_type pretty, :Bool, :pretty
      assert_type debug, :Bool, :debug
      assert_type use_env, :Bool, :use_env

      pretty  = pretty.to_bool
      debug   = debug.to_bool
      use_env = use_env.to_bool
      path    = unquote(path).to_s
      root    = use_env ? ENV["PWD"] : Dir.pwd
      dir     = Pathname.new(root) + path
      file    = File.basename dir, ".*"
      ext     = File.extname path
      message = "#{javascript?(ext) ? "JS" : "JSON"} to #{path}"
      map     = Sass::Script::Value::Map.new map.value
      hash    = map_to_h map

      output = if pretty
        JSON.pretty_generate hash
      else
        JSON.generate hash
      end

      if javascript? ext
        output = "var #{file} = #{output}"
      end

      if debug
        log :debug, %Q{
file: #{dir}
map: #{map.inspect}
hash: #{hash}
output: #{output}
}, :blue
      end

      write_dir Sass::Util.pathname(dir)

      if write_file dir, output
        log :export, message
      else
        message = "could not export #{message}"
        log :error, message, :red
      end

      Sass::Script::Value::String.new "exported #{message}"
    end
    declare :export, [:path, :map, :pretty, :debug, :use_env]

    private

    def log(action, message, color = :green)
      puts %Q(#{self.class.const_get(color.to_s.upcase)} #{action.to_s.rjust(8)}\e[0m #{message})
    end

    def javascript?(ext)
      ext == ".js"
    end

    def write_file(path, output)
      flag = Sass::Util.windows? ? "wb" : "w"
      begin
        File.open "#{path}", flag do |file|
          file.set_encoding output.encoding unless Sass::Util.ruby1_8?
          file.print output
        end
        true
      rescue
        false
      end
    end

    def write_dir(path)
      dir = File.dirname path

      unless File.exists?(dir)
        FileUtils.mkdir_p dir
        log :create, dir, :yellow
      end
    end

    def strip_quotes(value)
      if value.is_a?(String) || value.is_a?(Sass::Script::Value::String)
        unquote(value)
      else
        value
      end
    end

    def list_to_a(array)
      if array.is_a?(Array)
        array.map do |l|
          case l
          when Sass::Script::Value::Map
            l = map_to_h(l)
          when Sass::Script::Value::List
            l = list_to_a(l)
          when Sass::Script::Value::Bool
            l = l.to_bool
          when Sass::Script::Value::Number
            l = l.unitless? ? l.value : strip_quotes(l)
          when Sass::Script::Value::Color
            l = l.inspect
          else
            l = strip_quotes(l)
          end
          l
        end
      else
        list_to_a(array.to_a)
      end
    end

    def map_to_h(hash)
      if hash.is_a?(Hash)
        hash.inject({}) do |h, (k, v)|
          case v
          when Sass::Script::Value::Map
            h[strip_quotes(k)] = map_to_h(v)
          when Sass::Script::Value::List
            h[strip_quotes(k)] = list_to_a(v)
          when Sass::Script::Value::Bool
            h[strip_quotes(k)] = v.to_bool
          when Sass::Script::Value::Number
            h[strip_quotes(k)] = v.unitless? ? v.value : strip_quotes(v)
          when Sass::Script::Value::Color
            h[strip_quotes(k)] = v.inspect
          else
            h[strip_quotes(k)] = strip_quotes(v)
          end
          h
        end
      else
        map_to_h(hash.to_h)
      end
    end
  end
end
