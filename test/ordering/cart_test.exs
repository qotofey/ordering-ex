defmodule Ordering.CartTest do
  use ExUnit.Case
  doctest Ordering.Cart

  alias Ordering.Cart

  describe "new/0" do
    test "creates cart" do
      cart = Cart.new()
      assert %Cart{} = cart
      assert cart.items == %{}
    end
  end

  describe "set_item/2" do
  end
end
