defmodule SonaLiveCommentsWeb.PostLive.Show do
  use SonaLiveCommentsWeb, :live_view

  alias SonaLiveComments.PostRepository
  alias SonaLiveComments.CommentRepository

  def mount(params, _session, socket) do
    post = PostRepository.find(params["id"])

    :pg.join(String.to_atom(params["id"]), self())

    if post do
      comments = CommentRepository.find_all_by_post_id(post.id)
      {:ok, assign(socket, post: post, comments: comments)}
    else
      {:ok, socket}
    end
  end

  def handle_event("add-comment", %{"comment" => comment}, socket) do
    post_id = socket.assigns.post.id
    persisted_comment = CommentRepository.insert(comment, post_id)

    :pg.get_members(String.to_atom(post_id))
    |> Enum.each(fn pid -> send(pid, {:comment_added, persisted_comment}) end)

    {:noreply, socket}
  end

  def handle_info({:comment_added, comment}, socket) do
    {:noreply, assign(socket, comments: [comment | socket.assigns.comments])}
  end
end
