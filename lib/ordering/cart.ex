defmodule Ordering.Cart do
  defstruct items: %{}

  def new(), do: %Ordering.Cart{}

  def items(cart) do
    cart.items
    |> Enum.map(fn {_, item} -> item end)
  end

  def clear(cart) do
    %Ordering.Cart{cart | items: %{}}
  end
end
