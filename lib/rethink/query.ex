defmodule Rethink.Query do
  def encode(query, optargs) do
    {:ok, json} = JSX.encode([1, query, optargs])
    json
  end
end
