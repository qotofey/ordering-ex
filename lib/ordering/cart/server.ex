defmodule Ordering.Cart.Server do
  use GenServer

  alias Ordering.Cart

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def set_item(cart_server, new_item) do
    GenServer.cast(cart_server, {:set_item, new_item})
  end

  def get_items(cart_server) do
    GenServer.call(cart_server, {:items})
  end

  def remove_item(cart_server, product_id) do
    GenServer.cast(cart_server, {:remove_item, product_id})
  end

  def clear(cart_server) do
    GenServer.cast(cart_server, {:clear})
  end

  @impl GenServer
  def init(_) do
    {:ok, Cart.new()}
  end

  @impl GenServer
  def handle_call({:items}, _from, cart) do
    {:reply, Cart.items(cart), cart}
  end

  @impl GenServer
  def handle_cast({:set_item, item}, cart) do
    updated_cart = Cart.set_item(cart, item)

    {:noreply, updated_cart}
  end

  @impl GenServer
  def handle_cast({:remove_item, product_id}, cart) do
    updated_cart = Cart.remove_item(cart, product_id)

    {:noreply, updated_cart}
  end

  @impl GenServer
  def handle_cast({:clear}, cart) do
    updated_cart = Cart.clear(cart)

    {:noreply, updated_cart}
  end
end
