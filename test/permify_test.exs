defmodule PermifyTest do
  use ExUnit.Case
  doctest Permify

  test "greets the world" do
    assert Permify.hello() == :world
  end
end
