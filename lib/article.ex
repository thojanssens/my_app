defmodule MyApp.Article do
  use Ecto.Schema
  import Ecto.Changeset

  schema "articles" do
    field(:name, :string)
    has_many(:comments, MyApp.Comment, on_replace: :delete)
    timestamps(type: :utc_datetime)
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:name])
    |> cast_assoc(:comments)
  end
end
