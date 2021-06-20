defmodule MyApp do
  alias MyApp.Article
  alias MyApp.Comment
  alias MyApp.Repo

  def run() do
    Repo.delete_all(Comment)
    Repo.delete_all(Article)

    attrs = %{
      name: "An article",
      comments: [%{text: "A comment"}, %{text: "Another comment"}]
    }

    article =
      %Article{}
      |> Article.changeset(attrs)
      |> Repo.insert!()

    attrs = %{
      name: "Updated article",
      comments: [%{text: "A new comment"}, %{text: "Another new comment"}]
    }

    article_changeset = Article.changeset(article, attrs)

    # It is impossible to add some changes in a nested changeset if it is contained in a list with other changesets marked as :replace

    Ecto.Changeset.update_change(article_changeset, :comments, fn comment_changesets ->
      Enum.map(comment_changesets, fn
        %{action: action} = comment_changeset when action in [:replace, :delete] ->
          comment_changeset

        comment_changeset ->
          Ecto.Changeset.put_change(comment_changeset, :text, "Can't update :(")
      end)
    end)
  end
end
