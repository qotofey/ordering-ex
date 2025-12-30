defmodule Ordering.Cart do
  defstruct items: %{}

  def new(), do: %Ordering.Cart{}

  def set_item(cart, item) do
    new_items =
      Map.put(
        cart.items,
        item.product_id,
        item
      )

    %Ordering.Cart{cart | items: new_items}
  end

  def items(cart) do
    cart.items
    |> Enum.map(fn {_, item} -> item end)
  end

  def clear_item(cart, product_id) do
    new_items = Map.delete(cart.items, product_id)
    %Ordering.Cart{cart | items: new_items}
  end

  def clear_all(cart) do
    %Ordering.Cart{cart | items: %{}}
  end
end
