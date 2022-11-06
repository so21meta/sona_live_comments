defmodule SonaLiveCommentsWeb.PostLive.Index do
  use SonaLiveCommentsWeb, :live_view

  alias SonaLiveComments.PostRepository

  @impl true
  def mount(_params, _session, socket) do
    # get all posts
    {:ok, assign(socket, posts: PostRepository.find_all())}
  end

  @impl true
  def handle_event("add-post", %{"title" => title, "body" => body}, socket) do
    post = PostRepository.insert(%{title: title, body: body})
    {:noreply, assign(socket, posts: [post | socket.assigns.posts])}
  end
end
