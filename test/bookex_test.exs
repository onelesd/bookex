defmodule BookexTest do
  use ExUnit.Case
  doctest Bookex

  test "greets the world" do
    assert Bookex.hello() == :world
  end
end
