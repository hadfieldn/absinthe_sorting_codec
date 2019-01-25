defmodule AbsintheSdl.Utils do
  @moduledoc false
  def decorate(string, string_before, string_after) do
    string_before <> string <> string_after
  end

  def map_fields(fields, fun) do
    fields
    |> Enum.map_join("\n", fn field ->
      fun.(field)
    end)
    |> decorate("{\n", "\n}")
  end
end
