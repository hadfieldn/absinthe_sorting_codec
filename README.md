# AbsintheSdl

[![Build Status](https://travis-ci.com/maartenvanvliet/absinthe_sdl.svg?branch=master)](https://travis-ci.com/maartenvanvliet/absinthe_sdl) [![Hex pm](http://img.shields.io/hexpm/v/absinthe_sdl.svg?style=flat)](https://hex.pm/packages/absinthe_sdl) [![Hex Docs](https://img.shields.io/badge/hex-docs-9768d1.svg)](https://hexdocs.pm/absinthe_sdl) [![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Convert the json output of an introspection query into Graphql SDL syntax.

## Standalone
Can convert the output of introspection queries in json format to SDL. See the test fixtures.

### Example
```
AbsintheSdl.encode!(Jason.decode!("swapi.json"))
```

## Absinthe
Can be used to convert an Absinthe schema to SDL by using AbsintheSdl as the JSON
encoder.

### Example
```
mix absinthe.schema.json --schema MySchema --json-codec AbsintheSdl
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `absinthe_sdl` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:absinthe_sdl, "~> 1.0.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/absinthe_sdl](https://hexdocs.pm/absinthe_sdl).

