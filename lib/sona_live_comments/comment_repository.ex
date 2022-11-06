defmodule SonaLiveComments.CommentRepository do
  use GenServer

  alias Phoenix.PubSub
  alias SonaLiveComments.Comment

  @comments_table_name :comments

  def topic do
    "comments"
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def insert(comment, post_id) do
    GenServer.call(__MODULE__, {:insert, comment, post_id})
  end

  def find_all_by_post_id(post_id) do
    GenServer.call(__MODULE__, {:find_all_by_post_id, post_id})
  end

  def init(initial_state) do
    # set up ets table
    :ets.new(@comments_table_name, [:named_table])
    {:ok, initial_state}
  end

  def handle_call({:insert, new_comment, post_id}, _from, state) do
    comment = %Comment{id: UUID.uuid4(), post_id: post_id, body: new_comment}

    current_comments_for_post =
      case :ets.lookup(@comments_table_name, post_id) do
        [{_post_id, comments} | _] -> comments
        _ -> []
      end

    :ets.insert(
      @comments_table_name,
      {post_id, [comment | current_comments_for_post]}
    )

    {:reply, comment, state}
  end

  def handle_call({:find_all_by_post_id, post_id}, _from, state) do
    result =
      case :ets.lookup(@comments_table_name, post_id) do
        [{_post_id, comments} | _] -> comments
        _ -> []
      end

    {:reply, result, state}
  end
end
