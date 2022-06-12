defmodule BycodersCnab.Financial do
  @moduledoc """
  The Financial context.
  """

  import Ecto.Query, warn: false
  alias BycodersCnab.Repo

  alias BycodersCnab.Financial.Transaction

  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end
end
