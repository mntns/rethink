defmodule Rethink.Response do
  def decode(response) do
    JSX.decode!(response, [{:labels, :atom}])
  end

  def process(response) do
    decoded_response = decode(response)
    decoded_response[:r]
  end
end
