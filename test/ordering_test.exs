defmodule OrderingTest do
  use ExUnit.Case
  doctest Ordering

  test "greets the world" do
    assert Ordering.hello() == :world
  end
end
