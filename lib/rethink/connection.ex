defmodule Rethink.Connection do
  use GenServer

  @timeout :infinity

  # some supported opts:
  # :hostname
  # :port
  # :database
  # :auth_key
  # :timeout

  def start_link(opts) do
    opts = Enum.reject(opts, fn {_k, v} -> is_nil(v) end)
    case GenServer.start_link(__MODULE__, []) do
      {:ok, pid} ->
        timeout = opts[:timeout] || @timeout
        case apply(GenServer, :call, [pid, {:connect, opts}, timeout]) do
          :ok -> {:ok, pid}
          err -> {:error, err}
        end
      err -> err
    end
  end

  def stop(pid) do
    GenServer.call(pid, :stop)
  end

  def is_open(pid) do
    GenServer.call(pid, :open)
  end

  def run(query, pid) do
    GenServer.call(pid, {:run, query})
  end

  def use(pid, database) do
    GenServer.call(pid, {:use, database})
  end

  # Callbacks

  def init([]) do
    {:ok, %{sock: nil, database: nil, token: 1}}
  end

  def handle_call(:stop, _from, s) do
    # TODO: Add other reasons to stop?
    {:stop, :normal, s}
  end

  def handle_call(:open, _from, s) do
    # TODO: Implement something tasty!
    {:reply, true, s}
  end

  def handle_call({:connect, opts}, from, s) do
    socket = Socket.TCP.connect!(opts[:hostname], opts[:port])
    shake_hands!(socket, opts[:auth_key])
    GenServer.reply(from, :ok)
    {:noreply, %{s | sock: socket}}
  end

  def handle_call({:run, query}, _from, s) do
    # Send token
    q_token = <<s.token :: little-size(64)>>
    Socket.Stream.send!(s.sock, q_token)

    # Send query
    encoded_query = Rethink.Query.encode(query, [db: [14,[s.database]]])
    q_length = <<String.length(encoded_query) :: little-size(32)>>
    Socket.Stream.send!(s.sock, q_length)
    Socket.Stream.send!(s.sock, encoded_query)

    # Receive token and length
    r_token = Socket.Stream.recv!(s.sock, 8)
    <<r_length :: little-size(32)>> = Socket.Stream.recv!(s.sock, 4)

    # Receive response
    response = Socket.Stream.recv!(s.sock, r_length)

    # Parse and process the response
    p_response = Rethink.Response.process(response)

    {:reply, p_response, %{s | token: s.token + 1}}
  end

  def handle_call({:use, db}, _from, s) do
    {:reply, :ok, %{s | database: db}}
  end

  defp shake_hands!(socket, auth_key) do
    if auth_key do
      handshake = <<0x5f75e83e :: little-size(32), String.length(auth_key) :: little-size(32), auth_key, 0x7e6970c7 :: little-size(32)>> 
    else
      handshake = <<0x5f75e83e :: little-size(32), 0 :: little-size(32), 0x7e6970c7 :: little-size(32)>>
    end

    Socket.Stream.send!(socket, handshake)
    case Socket.Stream.recv!(socket) do
      "SUCCESS\0" -> :ok
      x           -> raise "error #{x}"
    end
  end

end
