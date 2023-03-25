defmodule CrashWeb.WidgetLive.Index do
  use CrashWeb, :live_view

  alias Crash.Store
  alias Crash.Store.Widget

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :widgets, Store.list_widgets())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Widget")
    |> assign(:widget, Store.get_widget!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Widget")
    |> assign(:widget, %Widget{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Widgets")
    |> assign(:widget, nil)
  end

  @impl true
  def handle_info({CrashWeb.WidgetLive.FormComponent, {:saved, widget}}, socket) do
    {:noreply, stream_insert(socket, :widgets, widget)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    widget = Store.get_widget!(id)
    {:ok, _} = Store.delete_widget(widget)

    {:noreply, stream_delete(socket, :widgets, widget)}
  end
end
