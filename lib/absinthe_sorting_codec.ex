defmodule AbsintheSortingCodec do
  @moduledoc """
  Convert the json output of an introspection query into JSON with types sorted by name.

  ## Example
  ```
  AbsintheSortingCodec.encode!(Jason.decode!("swapi.json"))
  ```

  Can be used to convert an Absinthe schema to a sorted, deterministic ordering
  by using AbsintheSortingCodec as the JSON encoder.

  ## Example
  ```
  mix absinthe.schema.json --schema MySchema --json-codec AbsintheSortingCodec
  ```

  """

  @doc """
  Partial implementation of JSON codec, enough to satisfy Absinthe when passing
  in AbsintheSortingCodec as codec.

  The schema passed in is the elixir representation of the json-result of an
  introspection query.
  """
  def encode!(schema, opts \\ []) do
    schema
    |> sorted_objects()
    |> Jason.encode!(opts)
  end

  defp sorted_objects(value)

  defp sorted_objects(map) when is_map(map) do
    for {key, val} <- map, into: %{}, do: {key, sorted_objects(val)}
  end

  defp sorted_objects(list) when is_list(list) do
    list
    |> Enum.sort_by(&list_sort_value/1)
    |> Enum.map(&sorted_objects/1)
  end

  defp sorted_objects(value), do: value

  defp list_sort_value(%{name: name}), do: name
  defp list_sort_value(_), do: ""
end
