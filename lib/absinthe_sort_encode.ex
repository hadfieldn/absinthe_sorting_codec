defmodule AbsintheSortEncode do

  @moduledoc """
  Convert the json output of an introspection query into JSON with types sorted by name.

  ## Example
  ```
  AbsintheSortEncode.encode!(Jason.decode!("swapi.json"))
  ```

  Can be used to convert an Absinthe schema to a sorted, deterministic ordering
  by using AbsintheSortEncode as the JSON encoder.

  ## Example
  ```
  mix absinthe.schema.json --schema MySchema --json-codec AbsintheSortEncode
  ```

  """

  @doc """
  Partial implementation of JSON codec, enough to satisfy Absinthe when passing
  in AbsintheSortEncode as codec.

  The schema passed in is the elixir representation of the json-result of an
  introspection query.
  """
  def encode!(schema, opts \\ []) do
    schema
    |> sorted_objects()
    |> Jason.encode!(opts)
  end

  def sort_schema(schema, opts \\ []) do
    sorted_objects(schema)
  end

  defp sorted_objects(map) when is_map(map) do
    for {key, val} <- map, into: %{}, do: {key, sorted_objects(val)}
  end
  defp sorted_objects(list) when is_list(list) do
    list
    |> Enum.sort_by(&list_sort_value/1)
    |> Enum.map(&sorted_objects/1)
  end

  defp list_sort_value(%{name: name }), do: name
  defp list_sort_value(_), do: ""

  defp sorted_objects(value) do
    value
  end
end
