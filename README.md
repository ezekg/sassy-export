# Sassy Export [![Gem Version](https://badge.fury.io/rb/sassy-export.svg)](http://badge.fury.io/rb/sassy-export)

Sassy Export is a lightweight Sass extension that allows you to export an encoded Sass map into an external JSON file. Use it anyway you like.

## Installation

1. `gem install sassy-export`
2. Add `require "sassy-export"` to your `config.rb`
3. Import into your stylesheet with `@import "sassy-export";`

## Documentation

#### Setup

Our file structure,
```
root
├── sass
│   ├── style.scss
├── json
└── config.rb
```

Sass,
```scss
// sass/style.scss

@import "sassy-export";

$map: (
	hello: world,
);

///
/// Convert passed map to json and write to <path>/<filename>.<ext>
///
/// @param {String} $path    - Directory path and filename
/// @param {Map}    $map     - Map to convert to json
/// @param {Bool}   $pretty  - Pretty print json
/// @param {Bool}   $debug   - Print debug string with path
/// @param {Bool}   $use_env - Use ENV["PWD"] for current directory instead of Dir.pwd
///
/// @return {String} - Write file to path
///
@include sassy-export("json/test.json", $map, true, true, false);
```

#### Result

New JSON file is created at `json/hello.json` (`$path` is relative to where your `config.rb` is located). Simply calling `@include sassy-export("hello.json", $map)` will write to your working directory.
```json
{
	"hello": "world"
}
```

#### Breakdown

The `sassy-export()` mixin takes a `\<directory\>/\<filename\>.\<ext\>` `$path` and a Sass `$map` as arguments. You can export straight to a JavaScript object by using the extension `.js` instead of `.json` for the output `$path`.

There are also optional arguments: `$pretty` which defaults to `false`, but will print pretty JSON (nicely indented) if set to `true`; and `$debug` which will print debug information if set to `true`.

It converts the `$map` into either a JSON map or Javascript object through Ruby, then creates a new directory/file (or updates an existing directory/file), and writes the contents of the JSON string to it.

Contributions are welcome. If you believe that you could improve the small amount of code here, feel free to.

Enjoy.
