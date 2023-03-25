defmodule Crash.Store.Widget do
  use Ecto.Schema
  import Ecto.Changeset

  schema "widgets" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(widget, attrs) do
    widget
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
