defmodule Ordering.Cart.ServerTest do
  use ExUnit.Case, async: true

  alias Ordering.Cart

  describe "get_items/1" do
    test "gets items of cart" do
      user_id = 417
      {:ok, pid} = Cart.Server.start(user_id)

      assert [] = Cart.Server.get_items(pid)
    end
  end

  describe "set_item/2" do
    test "creates item of cart" do
      user_id = 417
      {:ok, pid} = Cart.Server.start(user_id)

      Cart.Server.set_item(pid, %{product_id: 1, qty: 3})

      assert [%{product_id: 1, qty: 3}] = Cart.Server.get_items(pid)
    end
  end

  describe "remove_item/2" do
    test "removes item of cart" do
      user_id = 417
      {:ok, pid} = Cart.Server.start(user_id)
      Cart.Server.set_item(pid, %{product_id: 1, qty: 3})
      Cart.Server.set_item(pid, %{product_id: 2, qty: 1})

      assert [%{product_id: 1, qty: 3}, %{product_id: 2, qty: 1}] = Cart.Server.get_items(pid)
      Cart.Server.remove_item(pid, 1)

      assert [%{product_id: 2, qty: 1}] = Cart.Server.get_items(pid)
    end
  end

  describe "clear/1" do
    test "clears cart" do
      user_id = 417
      {:ok, pid} = Cart.Server.start(user_id)
      Cart.Server.set_item(pid, %{product_id: 1, qty: 3})
      Cart.Server.set_item(pid, %{product_id: 2, qty: 1})

      assert [%{product_id: 1, qty: 3}, %{product_id: 2, qty: 1}] = Cart.Server.get_items(pid)
      Cart.Server.clear(pid)

      assert [] = Cart.Server.get_items(pid)
    end
  end
end
