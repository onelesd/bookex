defmodule Bookex do
  @moduledoc """
  Bookex keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
end

defmodule Bookex.Author do
  @derive {Jason.Encoder, only: [:id, :name]}
  @enforce_keys [:id, :name]
  defstruct id: nil, name: nil, meta: %{}
  @type t :: %__MODULE__{id: String.t() | integer(), name: String.t(), meta: map()}
end

defmodule Bookex.Book do
  @derive {Jason.Encoder, only: [:id, :title, :thumb_url, :image_url]}
  @enforce_keys [:id, :title]
  defstruct id: nil, title: nil, thumb_url: nil, image_url: nil, meta: %{}
  @type t :: %__MODULE__{id: String.t() | integer(), title: String.t(), thumb_url: String.t(), image_url: String.t(), meta: map()}
end
