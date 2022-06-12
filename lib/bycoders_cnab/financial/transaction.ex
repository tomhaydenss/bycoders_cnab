defmodule BycodersCnab.Financial.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias BycodersCnab.Financial.TransactionType

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    field :amount, :decimal
    field :card, :string
    field :cpf, :string
    field :occurred_at, :utc_datetime
    field :owner_name, :string
    field :trading_name, :string
    field :transaction_type, Ecto.Enum, values: TransactionType.values()

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [
      :transaction_type,
      :amount,
      :cpf,
      :card,
      :owner_name,
      :trading_name,
      :occurred_at
    ])
    |> validate_required([
      :transaction_type,
      :amount,
      :cpf,
      :card,
      :owner_name,
      :trading_name,
      :occurred_at
    ])
  end
end
