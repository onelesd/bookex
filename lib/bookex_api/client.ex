defmodule Bookex.API.Client do
  @moduledoc """
  Fetch details about books and authors.
  """

  @adapter Application.get_env(:bookex, Bookex.API.Client)[:adapter]

  @spec search_author(String.t()) :: [Bookex.Author.t()]
  def search_author(query) do
    @adapter.search_author(query)
  end

  @spec find_author(String.t() | integer()) :: [Bookex.Author.t()]
  def find_author(query) do
    @adapter.find_author(query)
  end

  @spec search_book(String.t()) :: [Bookex.Book.t()]
  def search_book(query) do
    @adapter.search_book(query)
  end

  @spec find_book(String.t() | integer()) :: [Bookex.Book.t()]
  def find_book(query) do
    @adapter.find_book(query)
  end
end
