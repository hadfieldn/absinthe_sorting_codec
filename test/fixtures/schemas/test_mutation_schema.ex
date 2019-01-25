defmodule TestMutationSchema do
  use Absinthe.Schema

  query do
  end

  input_object :contact_input do
    field(:name, non_null(:float), default_value: 1.2)
    field(:value, non_null(:string))
  end

  mutation do
    @desc "Create a book"
    field :create_book, type: :string do
      arg(:body, non_null(:string), default_value: "body")
      arg(:title, non_null(:string))
      arg(:rating, :integer)
      arg(:contact, non_null(:contact_input))

      resolve(fn _, _, _ -> {:ok, %{}} end)
    end
  end
end
