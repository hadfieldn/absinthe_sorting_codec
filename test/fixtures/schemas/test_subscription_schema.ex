defmodule TestSubscriptionSchema do
  use Absinthe.Schema

  query do
  end

  object :comment do
    field(:name, :string)
  end

  subscription do
    field :comment_added, :comment do
      arg(:repo_name, non_null(:string))
    end
  end
end
