defmodule MyApp.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field(:text, :string)
    belongs_to(:article, MyApp.Article)
    timestamps(type: :utc_datetime)
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:id, :text])
  end
end
