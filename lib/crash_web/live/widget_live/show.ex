defmodule CrashWeb.WidgetLive.Show do
  use CrashWeb, :live_view

  alias Crash.Store

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:widget, Store.get_widget!(id))}
  end

  defp page_title(:show), do: "Show Widget"
  defp page_title(:edit), do: "Edit Widget"
end
