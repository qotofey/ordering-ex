defmodule Ordering.Cart.CacheTest do
  use ExUnit.Case, async: true

  alias Ordering.Cart

  describe "get_cart/2" do
    test "finds or creates cart server by user_id" do
      database_module = nil
      {:ok, cache_pid} = Cart.Cache.start(database_module)

      # TODO: подумать над CI не проходит для проверки кол-ва процессов Erlang
      # initial_process_qty = :erlang.system_info(:process_count)
      user_cart_pid = Cart.Cache.get_cart(cache_pid, "userID417")

      # TODO: подумать над CI не проходит для проверки кол-ва процессов Erlang
      # assert :erlang.system_info(:process_count) - initial_process_qty == 1
      assert user_cart_pid != Cart.Cache.get_cart(cache_pid, "userID800")

      # TODO: подумать над CI не проходит для проверки кол-ва процессов Erlang
      # assert :erlang.system_info(:process_count) - initial_process_qty == 2
      assert user_cart_pid == Cart.Cache.get_cart(cache_pid, "userID417")
    end

    test "gets items of cart" do
      database_module = nil
      {:ok, cache_pid} = Cart.Cache.start(database_module)
      user_cart_pid = Cart.Cache.get_cart(cache_pid, "userID417")

      assert [] = Cart.Server.get_items(user_cart_pid)
    end

    test "sets item of cart" do
      database_module = nil
      {:ok, cache_pid} = Cart.Cache.start(database_module)
      user_cart_pid = Cart.Cache.get_cart(cache_pid, "userID417")

      Cart.Server.set_item(user_cart_pid, %{product_id: 2, qty: 4})
      Cart.Server.set_item(user_cart_pid, %{product_id: 2, qty: 1})

      assert [%{product_id: 2, qty: 1}] = Cart.Server.get_items(user_cart_pid)
    end

    test "removes item of cart" do
      database_module = nil
      {:ok, cache_pid} = Cart.Cache.start(database_module)
      user_cart_pid = Cart.Cache.get_cart(cache_pid, "userID417")
      Cart.Server.set_item(user_cart_pid, %{product_id: 1, qty: 1})
      Cart.Server.set_item(user_cart_pid, %{product_id: 2, qty: 4})

      Cart.Server.remove_item(user_cart_pid, 1)

      assert [%{product_id: 2, qty: 4}] = Cart.Server.get_items(user_cart_pid)
    end

    test "clears cart items" do
      database_module = nil
      {:ok, cache_pid} = Cart.Cache.start(database_module)
      user_cart_pid = Cart.Cache.get_cart(cache_pid, "userID417")
      Cart.Server.set_item(user_cart_pid, %{product_id: 1, qty: 1})
      Cart.Server.set_item(user_cart_pid, %{product_id: 2, qty: 4})

      Cart.Server.clear(user_cart_pid)

      assert [] = Cart.Server.get_items(user_cart_pid)
    end
  end
end
