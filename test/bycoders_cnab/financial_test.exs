defmodule BycodersCnab.FinancialTest do
  use BycodersCnab.DataCase

  alias BycodersCnab.Financial

  describe "transactions" do
    alias BycodersCnab.Financial.Transaction

    @invalid_attrs %{
      amount: nil,
      card: nil,
      cpf: nil,
      occurred_at: nil,
      owner_name: nil,
      trading_name: nil,
      transaction_type: nil
    }

    test "create_transaction/1 with valid data creates a transaction" do
      transaction_type = random_transaction_type()

      valid_attrs = %{
        amount: "602.0",
        card: "6777****1313",
        cpf: "23270298056",
        occurred_at: ~U[2019-03-01 17:27:12Z],
        owner_name: "JOSÉ COSTA",
        trading_name: "MERCEARIA 3 IRMÃOS",
        transaction_type: transaction_type
      }

      assert {:ok, %Transaction{} = transaction} = Financial.create_transaction(valid_attrs)
      assert transaction.amount == Decimal.new("602.0")
      assert transaction.card == "6777****1313"
      assert transaction.cpf == "23270298056"
      assert transaction.occurred_at == ~U[2019-03-01 17:27:12Z]
      assert transaction.owner_name == "JOSÉ COSTA"
      assert transaction.trading_name == "MERCEARIA 3 IRMÃOS"
      assert transaction.transaction_type == transaction_type
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Financial.create_transaction(@invalid_attrs)
    end
  end

  defp random_transaction_type() do
    Ecto.Enum.values(BycodersCnab.Financial.Transaction, :transaction_type)
    |> Enum.take_random(1)
    |> hd()
  end
end
