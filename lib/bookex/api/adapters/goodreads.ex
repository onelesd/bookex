defmodule Bookex.API.Adapters.Goodreads do
  @behaviour Bookex.API.Adapters

  use Tesla
  import Meeseeks.XPath

  @moduledoc """
  Implement methods for Goodreads API. See: https://www.goodreads.com/api
  """

  @base_url Application.get_env(:bookex, Bookex.API.Adapters.Goodreads)[:base_url]
  @key Application.get_env(:bookex, Bookex.API.Adapters.Goodreads)[:key]

  plug(Tesla.Middleware.BaseUrl, @base_url)
  plug(Tesla.Middleware.Query, key: @key)
  plug(Tesla.Middleware.DebugLogger)

  # plug Tesla.Middleware.Tuples # return {:ok, env} | {:error, reason} instead of raising exception
  # plug(Tesla.Middleware.Logger)

  @doc """
  Get an xml response with the Goodreads url for the given author name.
  """
  @spec search_author(String.t()) :: [Bookex.Author.t()]
  def search_author(query) do
    response = get("/api/author_url/" <> query)

    case response.status do
      200 ->
        response.body
        |> Meeseeks.parse()
        |> Meeseeks.all(xpath("//goodreadsresponse/author"))
        |> Enum.map(fn author ->
          id = Meeseeks.attr(author, "id")

          name =
            Meeseeks.one(author, xpath("//name"))
            |> Meeseeks.data()

          %Bookex.Author{name: name, meta: %{goodreads: %{id: id}}}
        end)

      _ ->
        []
    end
  end

  @doc """
  Get an xml response with the Goodreads url for the given book title.
  """
  @spec search_book(String.t()) :: [Bookex.Book.t()]
  def search_book(query) do
    response = get("/search/index.xml", query: [q: query])

    case response.status do
      200 ->
        response.body
        |> Meeseeks.parse()
        |> Meeseeks.all(xpath("//goodreadsresponse/search/results/work"))
        |> Enum.map(fn work ->
          id =
            Meeseeks.one(work, xpath("//id"))
            |> Meeseeks.text()

          title =
            Meeseeks.one(work, xpath("//title"))
            |> Meeseeks.text()

          author_id =
            Meeseeks.one(work, xpath("//best_book/author/id"))
            |> Meeseeks.text()

          author_name =
            Meeseeks.one(work, xpath("//best_book/author/name"))
            |> Meeseeks.text()

          %Bookex.Book{
            title: title,
            meta: %{goodreads: %{id: id, author_id: author_id, author_name: author_name}}
          }
        end)

      _ ->
        []
    end
  end
end
