`Metado` is a tool for adding metadata to your TODOs.

## Idea

Add structure to TODOs to make it so that you can query them across a codebase.

This tool proposes a simple markup and provides a command line tool to parse it into JSON.
This leaves the user free to do whatever filtering they desire in their favourite language.

## Syntax rules

A metado is formed from consecutive single line comments and looks like this in a C based language:

```
// METADO: Remove this toggle before release
//   | This feature toggle should be removed with the release of Feature X
//   > fixVersion = "FeatureX"
```

- The first line denotes a metado with the token `METADO:` and the rest of the line acts as the metado's title.
- Any subsequent lines starting with a pipe ("|") create a longer form description for the metado.
- Any subsequent lines starting with a greater than operator (">") form the data portion of the metado and are parsed using TOML.

Running the tool on this readme would result in this output:

```
➜ metado path/to/readme/dir | jq .
[
  {
    "file": "path/to/readme/dir/README.md",
    "line_number": 0,
    "title": "Remove this toggle before release",
    "body": "This feature toggle should be removed with the release of Feature X",
    "data": {
      "fixVersion": "FeatureX"
    }
  }
]
```

## Example usage

Given the following metados in our source code:

```
// METADO: Remove this toggle before release
//   | This feature toggle should be removed with the release of Feature X
//   > fixVersion = "FeatureX"

// METADO: Spike implementation
//   | This is really inefficient and could be simplified.
//   > tags = ["performance", "spike"]

// METADO: This could do with a cache
//   > tags = ["performance"]
//   > fixVersion = "FeatureX"
```

If we wanted to check we have no work left to do before releasing "FeatureX" we could run the following query:

```
➜ metado Sources | jq 'map(select(.data.fixVersion == "FeatureX"))'
{
  "file": "Example.swift",
  "line_number": 27,
  "title": "Remove this toggle before release",
  "body": "This feature toggle should be removed with the release of Feature X",
  "data": {
    "fixVersion": "FeatureX"
  }
}
{
  "file": "Example.swift",
  "line_number": 16,
  "title": "This could do with a cache",
  "body": "",
  "data": {
    "tags": [
      "performance"
    ],
    "fixVersion": "FeatureX"
  }
}
```

If we wanted to find any metados that have been tagged as "performance" we could run the following query:

```
➜ metado Sources | jq 'map(select(.data.tags | index("performance")))'
[
  {
    "file": "Example.swift",
    "line_number": 12,
    "title": "Spike implementation",
    "body": "This is really inefficient and could be simplified.",
    "data": {
      "tags": [
        "performance",
        "spike"
      ]
    }
  },
  {
    "file": "Example.swift",
    "line_number": 16,
    "title": "This could do with a cache",
    "body": "",
    "data": {
      "tags": [
        "performance"
      ],
      "fixVersion": "FeatureX"
    }
  }
]
```

The key thing is that the metado tool outputs JSON so the filtering can be written in any language - the examples above use the `jq` command line tool.
Once the data is filtered the results could be used to notify people, fail CI builds or whatever could be useful for your project.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'metado'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install metado

## Usage

```
Usage: metado SOURCE_DIR
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/paulsamuels/metado.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
