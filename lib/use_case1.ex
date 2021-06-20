defmodule MyApp.UseCase1 do
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

    # Real use case 1: we have an Appointment and Contacts attending an appointment (represented here by Article and Comments).
    # The user is presented a dialog box to enter the appointment details as well as the contacts attending the appointment.
    # The user may enter a new contact, or search for an existing contact.
    # When he selects an existing contact, he can also update the details of the contact.
    # Through GraphQL I will receive attrs like such:
    # attrs = %{
    #   time: "15:30:00",
    #   contacts: [%{id: 143, name: "Updated coontact name"}, %{name: "A new contact"}]
    # }
    # The example attrs above show that, not only I want to add contact 143 and a new contact to the appointment, but also
    # update the contact 143 on the fly with a new name.

    # The code below works for an isnert but not for an update. Because of the problme mentioned in my_app.exs.

    # The idea is to accept the :id field when casting a Contact (here Comment), then load it from DB,
    # make sure the fetched contact is authorized for the current user, and then create a changeset, mark it as :update,
    # and finally add it into the list of Comment (Contact) changesets.

    changeset = Comment.changeset(%Comment{}, %{text: "Hello!"})
    %{id: comment_id} = Repo.insert!(changeset)

    attrs = %{
      name: "Updated article",
      comments: [%{id: comment_id, text: "Update this comment"}, %{text: "Another comment"}]
    }

    changeset = Article.changeset(article, attrs)

    case changeset do
      %{valid?: false} ->
        {:error, %{changeset | action: :insert}}

      _ ->
        comment_changesets =
          Ecto.Changeset.get_change(changeset, :comments, [])
          |> Enum.map(fn comment_changeset ->
            case Ecto.Changeset.fetch_change(comment_changeset, :id) do
              {:ok, id} ->
                case Repo.get(Comment, id) do
                  comment ->
                    # some authorization logic here
                    comment
                    |> Comment.changeset(comment_changeset.params)
                    |> Map.put(:action, :update)
                end

              :error ->
                comment_changeset
            end
          end)

        Ecto.Changeset.put_change(changeset, :comments, comment_changesets)
        |> Repo.update()
    end
  end
end
