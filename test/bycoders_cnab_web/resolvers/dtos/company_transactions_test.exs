defmodule BycodersCnabWeb.Resolvers.DTOs.CompanyTransactionsTest do
  use BycodersCnab.DataCase

  import BycodersCnab.TestHelpers

  alias BycodersCnab.Financial
  alias BycodersCnabWeb.Resolvers.DTOs.CompanyTransactions

  describe "from_transactions/1" do
    @tag :capture_log
    test "summarizing transactions" do
      filename = "CNAB.txt"
      file_path = path_to_fixture(filename)

      file_param = %{
        path: file_path,
        filename: filename
      }

      Financial.create_transaction_from_file(file_param)

      company_transactions =
        [asc: :trading_name, asc: :occurred_at]
        |> Financial.get_transactions()
        |> CompanyTransactions.from_transactions()

      expected_result = [
        %{
          trading_name: "BAR DO JOÃO",
          owner_name: "JOÃO MACEDO",
          balance: Decimal.new("-102.0")
        },
        %{
          trading_name: "LOJA DO Ó - FILIAL",
          owner_name: "MARIA JOSEFINA",
          balance: Decimal.new("152.32")
        },
        %{
          trading_name: "LOJA DO Ó - MATRIZ",
          owner_name: "MARIA JOSEFINA",
          balance: Decimal.new("230.0")
        },
        %{
          trading_name: "MERCADO DA AVENIDA",
          owner_name: "MARCOS PEREIRA",
          balance: Decimal.new("489.2")
        },
        %{
          trading_name: "MERCEARIA 3 IRMÃOS",
          owner_name: "JOSÉ COSTA",
          balance: Decimal.new("-7023.0")
        }
      ]

      assert Enum.count(expected_result) == Enum.count(company_transactions)

      company_transactions
      |> Enum.with_index()
      |> Enum.each(fn {company_info, idx} ->
        assert company_info.trading_name == Enum.at(expected_result, idx).trading_name
        assert company_info.owner_name == Enum.at(expected_result, idx).owner_name
        assert company_info.balance == Enum.at(expected_result, idx).balance
      end)
    end
  end
end
