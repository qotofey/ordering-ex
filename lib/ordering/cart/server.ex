defmodule Ordering.Cart.Server do
  use GenServer

  alias Ordering.Cart

  def start(user_id, database_module \\ nil) do
    GenServer.start(__MODULE__, {user_id, database_module})
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
  def init({user_id, database_module}) do
    {
      :ok,
      {
        user_id,
        database_module,
        (database_module && database_module.get(user_id)) || Cart.new()
      }
    }
  end

  @impl GenServer
  def handle_call({:items}, _from, {user_id, database_module, cart}) do
    {:reply, Cart.items(cart), {user_id, database_module, cart}}
  end

  @impl GenServer
  def handle_cast({:set_item, item}, {user_id, database_module, cart}) do
    updated_cart = Cart.set_item(cart, item)
    database_module && database_module.store(user_id, cart)

    {:noreply, {user_id, database_module, updated_cart}}
  end

  @impl GenServer
  def handle_cast({:remove_item, product_id}, {user_id, database_module, cart}) do
    updated_cart = Cart.remove_item(cart, product_id)
    database_module && database_module.store(user_id, cart)

    {:noreply, {user_id, database_module, updated_cart}}
  end

  @impl GenServer
  def handle_cast({:clear}, {user_id, database_module, cart}) do
    updated_cart = Cart.clear(cart)
    database_module && database_module.store(user_id, cart)

    {:noreply, {user_id, database_module, updated_cart}}
  end
end
