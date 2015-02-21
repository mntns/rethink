defmodule Rethink do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Rethink.Supervisor, [])
    ]

    opts = [strategy: :one_for_one, name: Rethink.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
