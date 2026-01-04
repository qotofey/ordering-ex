defmodule Ordering.Cart do
  defstruct items: %{}

  alias Ordering.Cart

  def new(items \\ []) do
    Enum.reduce(
      items,
      %Cart{},
      &set_item(&2, &1)
    )
  end

  def set_item(cart, item) do
    new_items =
      Map.put(
        cart.items,
        item.product_id,
        item
      )

    %Cart{cart | items: new_items}
  end

  def items(cart) do
    cart.items
    |> Enum.map(fn {_, item} -> item end)
  end

  def remove_item(cart, product_id) do
    new_items = Map.delete(cart.items, product_id)
    %Ordering.Cart{cart | items: new_items}
  end

  def clear(cart) do
    %Ordering.Cart{cart | items: %{}}
  end
end
