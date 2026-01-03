defmodule Ordering.Cart.Cache do
  use GenServer

  alias Ordering.Cart

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def get_cart(cache_pid, user_id) do
    GenServer.call(cache_pid, {:get_cart, user_id})
  end

  @impl GenServer
  def init(_) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:get_cart, user_id}, _, cart_servers) do
    case Map.fetch(cart_servers, user_id) do
      {:ok, cart_server} ->
        {:reply, cart_server, cart_servers}

      :error ->
        {:ok, new_cart_server} = Cart.Server.start()

        {
          :reply,
          new_cart_server,
          Map.put(cart_servers, user_id, new_cart_server)
        }
    end
  end
end
