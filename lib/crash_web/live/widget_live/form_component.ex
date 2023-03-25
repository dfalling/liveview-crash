defmodule CrashWeb.WidgetLive.FormComponent do
  use CrashWeb, :live_component

  alias Crash.Store

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage widget records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="widget-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Widget</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{widget: widget} = assigns, socket) do
    changeset = Store.change_widget(widget)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"widget" => widget_params}, socket) do
    changeset =
      socket.assigns.widget
      |> Store.change_widget(widget_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"widget" => widget_params}, socket) do
    save_widget(socket, socket.assigns.action, widget_params)
  end

  defp save_widget(socket, :edit, widget_params) do
    case Store.update_widget(socket.assigns.widget, widget_params) do
      {:ok, widget} ->
        notify_parent({:saved, widget})

        {:noreply,
         socket
         |> put_flash(:info, "Widget updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_widget(socket, :new, widget_params) do
    case Store.create_widget(widget_params) do
      {:ok, widget} ->
        notify_parent({:saved, widget})

        {:noreply,
         socket
         |> put_flash(:info, "Widget created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
