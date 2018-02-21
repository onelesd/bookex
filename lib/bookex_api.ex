defmodule Bookex.API do
  use Plug.Router
  require Logger

  plug Plug.Logger
  plug Plug.Parsers,
    parsers: [:json],
    json_decoder: Jason
  plug Plug.Static,
    at: "/",
    from: {:bookex, "priv/static"},
    only: ~w(js)
  plug :match
  plug :dispatch

  @scope "/api/v1"

  get @scope <> "/search_book/:title" do
    books = Bookex.API.Client.search_book(title)
    send_json_resp(conn, %{books: books})
  end

  get @scope <> "/find_book/:id" do
    result = Bookex.API.Client.find_book(id)
    send_json_resp(conn, result)
  end

  get "/" do
    send_resp(conn, 200, bootstrap())
  end

  match _ do
    send_resp(conn, 404, "not found")
  end

  defp send_json_resp(conn, resp) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, Jason.encode!(resp))
  end

  defp bootstrap do
    """
    <html>
    <head>
    <title>Bookex</title>
    <link rel="stylesheet" href="/js/app.css" />
    </head>
    <body>
    <script src="/js/app.js"></script>
    </body>
    </html>
    """
  end

  def init(options) do
    options
  end

  def start_link(_) do
    # NOTE: This starts Cowboy listening on the default port of 4000
    # cowboy_opts = [compress: true]
    cowboy_opts = []
    {:ok, _} = Plug.Adapters.Cowboy.http(__MODULE__, cowboy_opts)
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  # post "/hello" do
  #   {status, body} =
  #     case conn.body_params do
  #       %{"name" => name} -> {200, say_hello(name)}
  #       _ -> {422, missing_name()}
  #     end
  #   send_resp(conn, status, body)
  # end

  # defp say_hello(name) do
  #   Jason.encode!(%{response: "Hello, #{name}!"})
  # end

  # defp missing_name do
  #   Jason.encode!(%{error: "Expected a \"name\" key"})
  # end
end
