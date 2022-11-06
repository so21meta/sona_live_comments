defmodule SonaLiveComments.Post do
  @moduledoc """
  A struct representing a post.
  """

  use TypedStruct

  typedstruct do
    field(:id, String.t(), enforce: true)
    field(:title, String.t(), enforce: true)
    field(:body, String.t(), enforce: true)
  end
end
