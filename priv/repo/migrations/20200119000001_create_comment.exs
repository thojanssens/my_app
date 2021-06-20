defmodule MyApp.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :text, :string
      add :article_id, references(:articles), null: true
      timestamps()
    end
  end
end
