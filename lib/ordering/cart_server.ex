defmodule Ordering.CartServer do
  alias Ordering.Cart

  def start do
    spawn(fn -> loop(Cart.new()) end)
  end

  def set_item(cart_server, new_item) do
    send(cart_server, {:set_item, new_item})
  end

  def remove_item(cart_server, product_id) do
    send(cart_server, {:remove_item, product_id})
  end

  def clear(cart_server, {:clear}) do
    send(cart_server, {:clear})
  end

  def items(cart_server) do
    send(cart_server, {:items, self()})

    receive do
      {:items, items} -> items
    after
      5_000 -> {:error, :timeout}
    end
  end

  defp loop(cart) do
    updated_cart =
      receive do
        message -> process_message(cart, message)
      after
        5_000 -> {:error, :timeout}
      end

    loop(updated_cart)
  end

  defp process_message(cart, {:items, caller}) do
    send(caller, {:items, Cart.items(cart)})
    cart
  end

  defp process_message(cart, {:set_item, new_item}) do
    Cart.set_item(cart, new_item)
  end

  defp process_message(cart, {:remove_item, product_id}) do
    Cart.remove_item(cart, product_id)
  end

  defp process_message(cart, {:clear}) do
    Cart.clear(cart)
  end

  defp process_message(_cart, _), do: {:error, :unknown}
end
