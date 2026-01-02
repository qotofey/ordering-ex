defmodule Ordering.CartServerTest do
  use ExUnit.Case, async: true

  alias Ordering.CartServer

  describe "start/0" do
    test "creates cart" do
      cart_server = CartServer.start()

      assert CartServer.items(cart_server) == []
    end
  end
end
