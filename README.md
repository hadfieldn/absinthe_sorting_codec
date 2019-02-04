# Absinthe Sorting Codec

[![Build Status](https://travis-ci.com/hadfieldn/absinthe_sorting_codec.svg?branch=master)](https://travis-ci.com/hadfieldn/absinthe_sorting_codec) [![Hex pm](http://img.shields.io/hexpm/v/absinthe_sorting_codec.svg?style=flat)](https://hex.pm/packages/absinthe_sorting_codec) [![Hex Docs](https://img.shields.io/badge/hex-docs-9768d1.svg)](https://hexdocs.pm/absinthe_sorting_codec) [![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Convert the JSON output of an introspection query into a deterministic ordering of types (sorted by name).
This results in saner diffs when committing schemas to version control.

## Standalone
Can convert the output of introspection queries in JSON format to a sorted, deterministic ordering of types.
See the test fixtures.

### Example
```elixir
AbsintheSortingCodec.encode!(Jason.decode!("swapi.json"))
```

## Absinthe
Can be used to convert an Absinthe schema to a deterministic format by using AbsintheSortingCodec as the JSON
encoder. 

### Example
```bash
mix absinthe.schema.json --schema MySchema --json-codec AbsintheSortingCodec --pretty true
```

**NOTE:** If the mix command gives the following error -- 

```bash
(Argument Error) you atttempted to apply :module on "AbsintheSortingCodec". If you are using apply/3, make sure the module is an atom. If you are using the dot syntax, such as map.field or module.function, make sure the left side of the dot is an atom or a map
``` 

-- you need to upgrade to Absinthe [1.4.14](https://github.com/absinthe-graphql/absinthe/pull/605) or [later](https://github.com/absinthe-graphql/absinthe/pull/605). 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `absinthe_sorting_codec` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:absinthe_sorting_codec, "~> 1.0.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/absinthe_sorting_codec](https://hexdocs.pm/absinthe_sorting_codec).

## Attribution

Thanks to Maarten van Vliet for developing [Absinthe SDL](https://hex.pm/packages/absinthe_sdl), which this project is patterned after.

