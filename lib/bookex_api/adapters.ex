defmodule Bookex.API.Adapters do
  @callback search_author(String.t()) :: [Bookex.Author.t()]
  @callback find_author(String.t() | integer()) :: [Bookex.Author.t()]
  @callback search_book(String.t()) :: [Bookex.Book.t()]
  @callback find_book(String.t() | integer()) :: [Bookex.Book.t()]
end
