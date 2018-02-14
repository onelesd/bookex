defmodule Bookex.Author do
  @enforce_keys [:name]
  defstruct name: nil, meta: %{}
  @type t :: %__MODULE__{name: String.t(), meta: map()}
end

defmodule Bookex.Book do
  @enforce_keys [:title]
  defstruct title: nil, meta: %{}
  @type t :: %__MODULE__{title: String.t(), meta: map()}
end
