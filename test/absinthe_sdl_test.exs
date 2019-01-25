defmodule AbsintheSdlTest do
  @introspection_graphql Path.join([:code.priv_dir(:absinthe), "graphql", "introspection.graphql"])

  use ExUnit.Case

  test "it encodes a root query" do
    assert run(TestQuerySchema) == sdl_fixture("test_query_schema.graphql")
  end

  test "it encodes a mutation" do
    assert run(TestMutationSchema) == sdl_fixture("test_mutation_schema.graphql")
  end

  test "it encodes a subscription" do
    assert run(TestSubscriptionSchema) == sdl_fixture("test_subscription_schema.graphql")
  end

  test "it encodes an introspection query" do
    assert AbsintheSdl.encode!(json_fixture("swapi.json")) == sdl_fixture("test_swapi.graphql")
  end

  def sdl_fixture(file) do
    File.read!("test/fixtures/sdl/" <> file)
  end

  def json_fixture(file) do
    File.read!("test/fixtures/json/" <> file) |> Jason.decode!()
  end

  def run(schema) do
    {:ok, query} = File.read(@introspection_graphql)

    {:ok, result} = Absinthe.run(query, schema)
    AbsintheSdl.encode!(result)
  end
end
