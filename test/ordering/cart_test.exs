defmodule Ordering.CartTest do
  use ExUnit.Case, async: true
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
    test "add new product to empty cart" do
      # Given
      cart = Cart.new()
      item = %{product_id: 1, qty: 3}

      # When
      updated_cart = Cart.set_item(cart, item)

      # Then
      assert %Cart{} = updated_cart
      assert updated_cart.items[1] == item
    end

    test "update product in cart" do
      # Given
      cart = Cart.new()
      item = %{product_id: 1, qty: 7}
      cart = Cart.set_item(cart, item)
      new_item = %{product_id: 1, qty: 2}

      # When
      updated_cart = Cart.set_item(cart, new_item)

      # Then
      assert %Cart{} = updated_cart
      assert updated_cart.items[1] == new_item
      assert Enum.count(updated_cart.items) == 1
    end

    test "add product to cart" do
      # Given
      cart = Cart.new()
      item = %{product_id: 1, qty: 7}
      cart = Cart.set_item(cart, item)
      new_item = %{product_id: 3, qty: 2}

      # When
      updated_cart = Cart.set_item(cart, new_item)

      # Then
      assert %Cart{} = updated_cart
      assert updated_cart.items[3] == new_item
      assert Enum.count(updated_cart.items) == 2
    end
  end

  describe "remove_item/2" do
    test "removes product from cart" do
      # Given
      cart = Cart.new()
      item = %{product_id: 2, qty: 7}
      cart = Cart.set_item(cart, item)
      item = %{product_id: 3, qty: 2}
      cart = Cart.set_item(cart, item)

      # When
      updated_cart = Cart.remove_item(cart, 2)

      # Then
      assert %Cart{} = updated_cart
      assert updated_cart.items[3] == item
      assert Enum.count(updated_cart.items) == 1
    end
  end

  describe "clear/2" do
    test "clears cart" do
      # Given
      cart = Cart.new()
      item = %{product_id: 2, qty: 7}
      cart = Cart.set_item(cart, item)
      item = %{product_id: 3, qty: 2}
      cart = Cart.set_item(cart, item)

      # When
      updated_cart = Cart.clear(cart)

      # Then
      assert %Cart{} = updated_cart
      assert Enum.count(updated_cart.items) == 0
    end
  end
end
