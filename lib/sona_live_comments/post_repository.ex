defmodule SonaLiveComments.PostRepository do
  use GenServer

  alias SonaLiveComments.Post

  @posts_table_name :posts

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def insert(post) do
    GenServer.call(__MODULE__, {:insert, post})
  end

  def find(post_id) do
    GenServer.call(__MODULE__, {:find, post_id})
  end

  def find_all() do
    GenServer.call(__MODULE__, {:find_all})
  end

  def init(initial_state) do
    # set up ets table
    :ets.new(@posts_table_name, [:named_table])
    {:ok, initial_state}
  end

  def handle_call({:insert, new_post}, _from, state) do
    post = %Post{id: UUID.uuid4(), title: new_post.title, body: new_post.body}
    :ets.insert(@posts_table_name, {post.id, post})
    {:reply, post, state}
  end

  def handle_call({:find, post_id}, _from, state) do
    result =
      case :ets.lookup(@posts_table_name, post_id) do
        [{_id, post} | _] -> post
        [] -> nil
      end

    {:reply, result, state}
  end

  def handle_call({:find_all}, _from, state) do
    {:reply, Enum.map(:ets.tab2list(@posts_table_name), fn {_id, post} -> post end), state}
  end
end
