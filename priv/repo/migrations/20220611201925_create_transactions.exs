defmodule BycodersCnab.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :transaction_type, :int, null: false
      add :amount, :decimal, null: false
      add :cpf, :string, size: 11, null: false
      add :card, :string, size: 12, null: false
      add :owner_name, :string, size: 14, null: false
      add :trading_name, :string, size: 19, null: false
      add :occurred_at, :timestamptz, null: false

      timestamps()
    end
  end
end
