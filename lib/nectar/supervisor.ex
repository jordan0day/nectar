defmodule Nectar.Supervisor do
  @moduledoc """
  Documentation for Nectar.Supervisor.
  """

  use Supervisor

  def start_link(socket, concurrency) do
    Supervisor.start_link(__MODULE__, {socket, concurrency}, name: __MODULE__)
  end

  def init({socket, concurrency}) do
    children =
      0..concurrency
      |> Enum.map(fn n ->
        worker(Nectar.Worker, [socket], restart: :permanent, id: :"worker#{n}")
      end)

    Supervisor.init(children, strategy: :one_for_one, max_restarts: 100_000_000, max_seconds: 1)
  end
end
