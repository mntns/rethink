defmodule Rethink.Response do
  @moduledoc """
  Decrypts the response.
  """
  
  @doc "Decodes the raw response. JSON -> Usable data."
  def decode(response) do
    JSX.decode!(response, [{:labels, :atom}])
  end

  @doc "Does something with the data from the request and returns the actual response."
  def process(response) do
    decoded_response = decode(response)
    decoded_response[:r]
  end
end
