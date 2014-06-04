# SassyExport [![Gem Version](https://badge.fury.io/rb/SassyExport.svg)](http://badge.fury.io/rb/SassyExport)

SassyExport is a lightweight Compass extension that allows you to export an encoded Sass map into an external JSON file. Use it anyway you like.

## Installation

1. `gem install SassyExport`
2. Add `require "SassyExport"` to your `config.rb`
3. Import into your stylesheet with `@import "SassyExport";`

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
// ./sass/style.scss

@import "SassyExport";

$map: (
	hello: world,
);

// SassyExport : convert passed map to json and write to path/to/filename.json
// ----------------------------------------------------------------------------------------------------
// @param $path [string] : directory path and filename
// @param $map [map] : map to convert to json
// @param $pretty [bool] : pretty print json
// ----------------------------------------------------------------------------------------------------
// @return $string | write json to path

@include SassyExport("/json/hello.json", $map, true);
```

#### Result

New JSON file is created at `./json/hello.json`. As you can see, `$path` is relative to where your `config.rb` is located. Simply calling `@include SassyExport("/hello.json", $map)` will write to your directory root.
```json
{
	"hello": "world"
}
```

#### Breakdown

The `SassyExport()` mixin takes a directory/filename.json `$path`, and a Sass `$map` as arguments. It converts the `$map` into a JSON map through Ruby, and then creates a new file (or updates an existing file), and writes the contents of the json string to it. I'm no Ruby expert, so if you belive that you could improve the small amount of code here, feel free to.

Enjoy.

## SassyJSON

* [Download SassyJSON](https://github.com/HugoGiraudel/SassyJSON)
