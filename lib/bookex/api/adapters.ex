defmodule Bookex.API.Adapters do
  @callback search_author(String.t()) :: [Bookex.Author.t()]
  @callback search_book(String.t()) :: [Bookex.Book.t()]
end
