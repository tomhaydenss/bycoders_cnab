defmodule BycodersCnabWeb.Resolvers.DTOs.CompanyTransactions do
  @moduledoc """
    Converts Transactions from ecto schema into a data struct to be used by a GraphQL client
  """

  alias BycodersCnab.Financial.Transaction
  alias BycodersCnab.Financial.TransactionType

  @type company_transaction :: %{
          trading_name: String.t(),
          owner_name: String.t(),
          balance: float(),
          transactions: list(transaction())
        }
  @type transaction :: %{
          amount: float(),
          card: String.t(),
          cpf: String.t(),
          occurred_at: DateTime.t(),
          transaction_type: atom()
        }

  @spec from_transactions(list(Transaction.t())) :: list(company_transaction())
  def from_transactions(transactions) do
    transactions
    |> Enum.map(&company_and_owner/1)
    |> Enum.uniq()
    |> Enum.map(&summarize_transactions(&1, transactions))
  end

  defp company_and_owner(transaction), do: Map.take(transaction, [:trading_name, :owner_name])

  defp summarize_transactions(company_info, transactions) do
    company_transactions =
      transactions
      |> Enum.filter(&filter_by_trading_and_owner(&1, company_info))
      |> Enum.map(&Map.drop(&1, [:id, :inserted_at, :updated_at, :owner_name, :trading_name]))

    balance =
      company_transactions
      |> Enum.reduce(
        0,
        fn
          %{transaction_type: transaction_type, amount: amount}, acc ->
            case TransactionType.operation(transaction_type) do
              :income ->
                acc + Decimal.to_float(amount)

              :expense ->
                acc - Decimal.to_float(amount)
            end
        end
      )

    company_info
    |> Map.put(:balance, Decimal.new("#{balance}"))
    |> Map.put(:transactions, company_transactions)
  end

  defp filter_by_trading_and_owner(transaction, company_info) do
    transaction.trading_name == company_info.trading_name and
      transaction.owner_name == company_info.owner_name
  end
end
