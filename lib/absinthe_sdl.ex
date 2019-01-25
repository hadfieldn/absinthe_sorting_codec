defmodule AbsintheSdl do
  import AbsintheSdl.Utils

  @moduledoc """
  Convert the json output of an introspection query into Graphql SDL syntax.

  ## Example
  ```
  AbsintheSdl.encode!(Jason.decode!("swapi.json"))
  ```

  Can be used to convert an Absinthe schema to SDL by using AbsintheSdl as the JSON
  encoder.

  ## Example
  ```
  mix absinthe.schema.json --schema MySchema --json-codec AbsintheSdl
  ```

  """
  @default_scalars [
    "Boolean",
    "ID",
    "String",
    "Float",
    "Int"
  ]
  @doc """
  Partial implementation of JSON codec, enough to satisfy Absinthe when passing
  in AbsintheSdl as codec.

  The schema passed in is the elixir representation of the json-result of an
  introspection query.
  """
  def encode!(schema, _opts \\ []) do
    schema = schema_from_data(schema)

    root_nodes(schema) <> type_nodes(schema)
  end

  defp schema_from_data(%{"data" => %{"__schema" => schema}}), do: schema
  defp schema_from_data(%{data: %{"__schema" => schema}}), do: schema

  defp type_nodes(%{"types" => types}) do
    types
    |> Enum.sort_by(fn %{"name" => name} -> name end)
    |> Enum.map_join(fn type ->
      type_node(type)
    end)
  end

  defp type_node(%{"name" => name}) when name in @default_scalars, do: ""
  # Skip reserved names
  defp type_node(%{"name" => "__" <> _}), do: ""

  defp type_node(type) do
    """
    #{type_description(type)}
    #{type(type)} #{type_name(type)}#{with_interfaces(type)} #{type_fields(type)}
    """
  end

  defp type_name(%{"name" => name}), do: name

  defp with_interfaces(%{"interfaces" => nil}), do: ""
  defp with_interfaces(%{"interfaces" => []}), do: ""

  defp with_interfaces(%{"interfaces" => interfaces}) do
    interfaces = interfaces |> Enum.map_join(", ", fn %{"name" => name} -> name end)
    " implements " <> interfaces
  end

  defp type(%{"kind" => "INTERFACE"}), do: "interface"
  defp type(%{"kind" => "UNION"}), do: "union"
  defp type(%{"kind" => "ENUM"}), do: "enum"
  defp type(%{"kind" => "SCALAR"}), do: "scalar"
  defp type(%{"kind" => "INPUT_OBJECT"}), do: "input"
  defp type(%{"kind" => "OBJECT"}), do: "type"

  defp field_description(%{"description" => nil}), do: ""

  defp field_description(%{"description" => description}) do
    "\"\"\"#{description}\"\"\"\n  "
  end

  defp type_description(%{"description" => nil}), do: ""

  defp type_description(%{"description" => description}) do
    "\n\"\"\"#{description}\"\"\""
  end

  defp type_fields(%{"kind" => "UNION", "possibleTypes" => possible_types}) do
    types =
      possible_types
      |> Enum.map_join(" | ", fn %{"name" => name} ->
        name
      end)

    "= #{types}"
  end

  defp type_fields(%{"kind" => "INPUT_OBJECT", "inputFields" => input_fields}) do
    map_fields(input_fields, &field_node/1)
  end

  defp type_fields(%{"kind" => "ENUM", "enumValues" => enum_values}) do
    map_fields(enum_values, &enum_value/1)
  end

  defp type_fields(%{"kind" => "SCALAR"}), do: ""
  defp type_fields(%{"fields" => nil}), do: ""

  defp type_fields(%{"fields" => fields}) do
    map_fields(fields, &field_node/1)
  end

  defp enum_value(field) do
    """
      #{field_description(field)}#{field["name"]}#{field_deprecated(field)}\
    """
  end

  defp field_node(field) do
    """
      #{field_description(field)}#{field["name"]}#{field_args(field)}: #{
      field_type(field["type"])
    }#{field_default_value(field)}#{field_deprecated(field)}\
    """
  end

  defp field_args(%{"args" => []}), do: ""

  defp field_args(%{"args" => args}) do
    args
    |> Enum.map_join(", ", fn arg ->
      "#{arg["name"]}: #{field_type(arg["type"])}#{field_default_value(arg)}"
    end)
    |> decorate("(", ")")
  end

  defp field_args(_), do: ""

  defp field_default_value(%{"defaultValue" => nil}), do: ""
  defp field_default_value(%{"defaultValue" => value}), do: " = #{value}"
  defp field_default_value(_), do: ""

  defp field_deprecated(%{"isDeprecated" => false}), do: ""

  defp field_deprecated(%{"isDeprecated" => true, "deprecationReason" => reason}) do
    " @deprecated" <> field_deprecation_reason(reason)
  end

  defp field_deprecated(_), do: ""

  defp field_deprecation_reason(nil), do: ""

  defp field_deprecation_reason(reason) do
    "(reason: \"#{reason}\")"
  end

  defp field_type(%{"kind" => "LIST", "ofType" => type}),
    do: type |> field_type |> decorate("[", "]")

  defp field_type(%{"kind" => "NON_NULL", "ofType" => type}), do: field_type(type) <> "!"
  defp field_type(%{"kind" => _, "name" => name, "ofType" => _}), do: name

  defp root_nodes(schema) do
    """
    schema {
    #{query_type(schema)}#{mutation_type(schema)}#{subscription_type(schema)}\
    }
    """
  end

  defp query_type(%{"queryType" => %{"name" => name}}) do
    "  query: #{name}\n"
  end

  defp query_type(_), do: ""

  defp mutation_type(%{"mutationType" => %{"name" => name}}) do
    "  mutation: #{name}\n"
  end

  defp mutation_type(_), do: ""

  defp subscription_type(%{"subscriptionType" => %{"name" => name}}) do
    "  subscription: #{name}\n"
  end

  defp subscription_type(_), do: ""
end
