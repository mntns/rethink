defmodule Rethink.Query do
  @moduledoc """
  The purpose of this module is to craft the query for the RethinkDB server.
  """
  
  @doc "Encodeds the term (and the 'optargs') to the final query."
  def encode(query, optargs) do
    {:ok, json} = JSX.encode([1, query, optargs])
    json
  end
end
