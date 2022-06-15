defmodule BycodersCnab.Financial.Transaction do
  @moduledoc """
    Schema definition to represents financial transactions of a company
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias BycodersCnab.Financial.TransactionType

  @type t :: %__MODULE__{}

  @all_fields ~w[transaction_type amount cpf card owner_name trading_name occurred_at]a

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
    |> cast(attrs, @all_fields)
    |> validate_required(@all_fields)
    |> unique_constraint(@all_fields, name: :unique_transaction_index)
  end
end
