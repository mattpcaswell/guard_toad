defmodule GuardToadTest do
  use ExUnit.Case
  doctest GuardToad

  test "greets the world" do
    assert GuardToad.hello() == :world
  end
end
