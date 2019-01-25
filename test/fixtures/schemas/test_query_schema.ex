defmodule TestQuerySchema do
  use Absinthe.Schema

  query do
    @desc "An item"
    field :item, :item do
      @desc "Argument description"
      arg(:id, non_null(:id), default_value: "abc")
    end

    field(:search_result, list_of(:search_result))
  end

  @desc "An item"
  object :item do
    @desc "Item field description"
    field(:item, non_null(:item), deprecate: "deprecated reason")
    field(:items, non_null(list_of(non_null(:item))))
    @desc "Enum description"
    field(:color, :color)
    @desc "Custom scalar description"
    field(:time, :time)
    interface(:named_entity)
    interface(:timed_entity)
    field(:name, :string)
    is_type_of(:timed_entity)
  end

  object :union_item do
    field(:name, :string)
  end

  interface :timed_entity do
    field(:time, :time)
  end

  interface :named_entity do
    field(:name, :string)

    resolve_type(fn
      %{age: _}, _ -> :item
      %{employee_count: _}, _ -> :string
      _, _ -> nil
    end)
  end

  union :search_result do
    description("A search result")

    types([:item, :union_item])

    resolve_type(fn
      :bogus, _ -> :item
      _, _ -> :string
    end)
  end

  enum :color do
    value(:red, as: "r", description: "reddish")
    value(:green, as: "g", deprecate: "no more green")
    value(:blue, as: "b")
  end

  scalar :time do
    description("Time (in ISOz format)")
    parse(&parse(&1, "{ISOz}"))
    serialize(&serialize(&1, "{ISOz}"))
  end

  def parse(_, _) do
    ""
  end

  def serialize(_, _) do
    ""
  end
end
