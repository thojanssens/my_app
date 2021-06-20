defmodule MyApp.UseCase2 do
  # I have a module that will review changes in changesets (for example authorizing tenant ids).
  # It needs to add changes such as errors.

  # For a list of changesets where some are to be :replace-d, no update is possible.

  # It was solved though by adding an error in the parent changesets saying "some entries are unauthorized"
  # even though slightly suboptimal
end
