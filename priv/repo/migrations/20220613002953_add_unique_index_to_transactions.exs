defmodule BycodersCnab.Repo.Migrations.AddUniqueIndexToTransactions do
  use Ecto.Migration

  def change do
    create index(
             "transactions",
             [:transaction_type, :amount, :cpf, :card, :owner_name, :trading_name, :occurred_at],
             unique: true,
             name: :unique_transaction_index
           )
  end
end
