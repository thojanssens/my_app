defmodule MyApp.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :name, :string
      timestamps()
    end
  end
end
