defmodule Rethink.Response.Test do
  use ExUnit.Case

  test "gives back actual resp" do
    assert Rethink.Response.process('{"t":1,"r":[7]}') == [7]
  end
end
