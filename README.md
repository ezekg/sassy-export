# SassyExport

SassyExport is a lightweight plugin for [SassyJSON](https://github.com/HugoGiraudel/SassyJSON) that allows you to export an encoded Sass map into an external JSON file. SassyExport provides an easy way to export a Sass map into an external JSON file to be used anyway you like.

## Installation

1. `gem install SassyExport`
2. Add `require "SassyExport"` to your `config.rb`
3. Import it in your stylesheets with `@import "SassyExport";`

## Documentation

#### Sass
```scss
// ./sass/SassyExport.scss

@mixin json_export($path, $filename, $map) {
	@at-root {
		%json_export {
			content: "#{SassyJSON_export(unquote($path), unquote($filename), unquote(json_encode($map)))}";
		}
	}
}
```

```scss
// ./sass/style.scss

@import "SassyExport";

$map: (
	hello: world,
);

@include json_export("../json", "hello", $map);
```

#### Result
New JSON file is created in `./json/hello.json`
```json
{"hello": "world"}
```

The `json_export()` mixin takes a directory `$path`, `$filename`, and a Sass `$map` as arguments, then it converts the `$map` to a JSON map with the `json_encode()` function, then Ruby creates a new file (or updates an existing file), and writes the contents of the json string to it. I'm no Ruby expert, so if you belive that you could improve the small amount of code here, feel free to.

Might as well, right?

## SassyJSON

* [Download SassyJSON](https://github.com/HugoGiraudel/SassyJSON)

## Credits

* [Fabrice Weinberg](http://twitter.com/fweinb)
* [Hugo Giraudel](http://twitter.com/hugogiraudel)
