defmodule Ordering.Cart.CacheTest do
  use ExUnit.Case, async: true

  alias Ordering.Cart

  describe "get_cart/2" do
    test "finds or creates cart server by user_id" do
      {:ok, cache_pid} = Cart.Cache.start()
      initial_process_qty = :erlang.system_info(:process_count)
      user_cart_pid = Cart.Cache.get_cart(cache_pid, "userID417")

      assert :erlang.system_info(:process_count) - initial_process_qty == 1
      assert user_cart_pid != Cart.Cache.get_cart(cache_pid, "userID800")

      assert :erlang.system_info(:process_count) - initial_process_qty == 2
      assert user_cart_pid == Cart.Cache.get_cart(cache_pid, "userID417")
    end

    test "gets items of cart" do
      {:ok, cache_pid} = Cart.Cache.start()
      user_cart_pid = Cart.Cache.get_cart(cache_pid, "userID417")

      assert user_cart_pid |> Cart.Server.get_items() == []
    end

    test "sets item of cart" do
      {:ok, cache_pid} = Cart.Cache.start()
      user_cart_pid = Cart.Cache.get_cart(cache_pid, "userID417")

      Cart.Server.set_item(user_cart_pid, %{product_id: 2, qty: 4})
      Cart.Server.set_item(user_cart_pid, %{product_id: 2, qty: 1})

      assert Cart.Server.get_items(user_cart_pid) == [%{product_id: 2, qty: 1}]
    end

    test "removes item of cart" do
      {:ok, cache_pid} = Cart.Cache.start()
      user_cart_pid = Cart.Cache.get_cart(cache_pid, "userID417")
      Cart.Server.set_item(user_cart_pid, %{product_id: 1, qty: 1})
      Cart.Server.set_item(user_cart_pid, %{product_id: 2, qty: 4})

      Cart.Server.remove_item(user_cart_pid, 1)

      assert Cart.Server.get_items(user_cart_pid) == [%{product_id: 2, qty: 4}]
    end

    test "clears cart items" do
      {:ok, cache_pid} = Cart.Cache.start()
      user_cart_pid = Cart.Cache.get_cart(cache_pid, "userID417")
      Cart.Server.set_item(user_cart_pid, %{product_id: 1, qty: 1})
      Cart.Server.set_item(user_cart_pid, %{product_id: 2, qty: 4})

      Cart.Server.clear(user_cart_pid)

      assert Cart.Server.get_items(user_cart_pid) == []
    end
  end
end
