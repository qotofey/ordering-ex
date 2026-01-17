defmodule Ordering.Cart.Database.Pool do
  use GenServer

  @db_folder "./persist"
  @pool_size 4

  alias Ordering.Cart

  def start do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def store(key, data) do
    key
    |> choose_worker()
    |> Cart.Database.Worker.store(key, data)
  end

  def get(key) do
    key
    |> choose_worker()
    |> Cart.Database.Worker.get(key)
  end

  def choose_worker(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  @impl GenServer
  def init(_) do
    File.mkdir_p!(@db_folder)

    {:ok, start_workers()}
  end

  @impl GenServer
  def handle_call({:get, key}, _from, workers) do
    worker_key = :erlang.phash2(key, @pool_size)

    {
      :reply,
      Map.get(workers, worker_key),
      workers
    }
  end

  defp start_workers() do
    for index <- 1..3, into: %{} do
      {:ok, pid} = Cart.Database.Worker.start(@db_folder)
      {index - 1, pid}
    end
  end
end
