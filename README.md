# SassyExport

SassyExport is a lightweight plugin for [SassyJSON](https://github.com/HugoGiraudel/SassyJSON) that allows you to export an encoded Sass map into an external JSON file. Use it anyway you like.

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
└── json
```

Sass,
```scss
// ./sass/style.scss

@import "SassyExport";

$map: (
	hello: world,
);

@include SassyExport("/json", "hello", $map);
```

#### Result

New JSON file is created in `./json/hello.json`. As you can see, `$path` is relative to where your `config.rb` is located. Simply calling `@include SassyExport("/", "hello", $map)` will write to your directory root.
```json
{"hello": "world"}
```

====

The `json_export()` mixin takes a directory `$path`, `$filename`, and a Sass `$map` as arguments. It then converts the `$map` into a JSON map with SassyJSON's `json_encode()` function, then Ruby creates a new file (or updates an existing file), and writes the contents of the json string to it. I'm no Ruby expert, so if you belive that you could improve the small amount of code here, feel free to.

Enjoy.

## SassyJSON

* [Download SassyJSON](https://github.com/HugoGiraudel/SassyJSON)

## Credits

* [Fabrice Weinberg](http://twitter.com/fweinb)
* [Hugo Giraudel](http://twitter.com/hugogiraudel)
