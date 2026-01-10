defmodule Ordering.System do
  use Supervisor

  alias Ordering.Cart

  def start_link do
    Supervisor.start_link(__MODULE__, nil)
  end

  def init(_) do
    [Cart.Cache]
    |> Supervisor.init(strategy: :one_for_one)
  end
end
