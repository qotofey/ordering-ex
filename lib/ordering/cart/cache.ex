defmodule Ordering.Cart.Cache do
  use GenServer

  alias Ordering.Cart

  def start_link(_) do
    # database_module = Cart.Database.Pool
    database_module = nil
    IO.puts("Starting cart cache.")
    GenServer.start(__MODULE__, database_module)
  end

  def get_cart(cache_pid, user_id) do
    GenServer.call(cache_pid, {:get_cart, user_id})
  end

  @impl GenServer
  def init(database_module) do
    database_module && database_module.start()

    {:ok, {database_module, %{}}}
  end

  @impl GenServer
  def handle_call({:get_cart, user_id}, _, {database_module, cart_servers}) do
    case Map.fetch(cart_servers, user_id) do
      {:ok, cart_server} ->
        {:reply, cart_server, {database_module, cart_servers}}

      :error ->
        {:ok, new_cart_server} = Cart.Server.start(user_id, database_module)

        {
          :reply,
          new_cart_server,
          {database_module, Map.put(cart_servers, user_id, new_cart_server)}
        }
    end
  end
end
