defmodule SonaLiveComments.Comment do
  @moduledoc """
  A struct representing a comment.
  """

  use TypedStruct

  typedstruct do
    field(:id, String.t(), enforce: true)
    field(:post_id, String.t(), enforce: true)
    field(:body, String.t(), enforce: true)
  end
end
