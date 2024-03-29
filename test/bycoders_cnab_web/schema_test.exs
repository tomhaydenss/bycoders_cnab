defmodule BycodersCnabWeb.SchemaTest do
  use BycodersCnabWeb.ConnCase

  import BycodersCnab.TestHelpers

  alias BycodersCnab.Financial
  alias BycodersCnab.Financial.Transaction
  alias BycodersCnab.Financial.TransactionType
  alias BycodersCnab.Repo

  describe "uploading a cnab file" do
    @upload_file_mutation """
    mutation {
      uploadFile(file: "cnab_file")
    }
    """

    test "successfully", %{conn: conn} do
      filename = "valid_cnab_file.txt"

      cnab_file = %Plug.Upload{
        content_type: "text/plain",
        path: path_to_fixture(filename),
        filename: filename
      }

      body =
        conn
        |> post("/api/graphql", %{query: @upload_file_mutation, cnab_file: cnab_file})
        |> json_response(200)

      assert %{"data" => %{"uploadFile" => "file_uploaded_succesfully"}} = body

      records = Repo.all(Transaction)
      assert [first, second, third, fourth] = records

      assert Enum.count(records) == 4
      assert first.amount == Decimal.new("142.0")
      assert first.card == "4753****3153"
      assert first.cpf == "09620676017"
      assert first.occurred_at == ~U[2019-03-01 15:34:53Z]
      assert first.owner_name == "JOÃO MACEDO"
      assert first.trading_name == "BAR DO JOÃO"
      assert first.transaction_type == TransactionType.for(3)

      assert second.amount == Decimal.new("132.0")
      assert second.card == "3123****7687"
      assert second.cpf == "55641815063"
      assert second.occurred_at == ~U[2019-03-01 14:56:07Z]
      assert second.owner_name == "MARIA JOSEFINA"
      assert second.trading_name == "LOJA DO Ó - MATRIZ"
      assert second.transaction_type == TransactionType.for(5)

      assert third.amount == Decimal.new("122.0")
      assert third.card == "6777****1313"
      assert third.cpf == "84515254073"
      assert third.occurred_at == ~U[2019-03-01 17:27:12Z]
      assert third.owner_name == "MARCOS PEREIRA"
      assert third.trading_name == "MERCADO DA AVENIDA"
      assert third.transaction_type == TransactionType.for(3)

      assert fourth.amount == Decimal.new("602.0")
      assert fourth.card == "6777****1313"
      assert fourth.cpf == "23270298056"
      assert fourth.occurred_at == ~U[2019-03-01 17:27:12Z]
      assert fourth.owner_name == "JOSÉ COSTA"
      assert fourth.trading_name == "MERCEARIA 3 IRMÃOS"
      assert fourth.transaction_type == TransactionType.for(3)
    end

    @tag :capture_log
    test "with no records imported", %{conn: conn} do
      filename = "invalid_cnab_file.txt"

      cnab_file = %Plug.Upload{
        content_type: "text/plain",
        path: path_to_fixture(filename),
        filename: filename
      }

      body =
        conn
        |> post("/api/graphql", %{query: @upload_file_mutation, cnab_file: cnab_file})
        |> json_response(200)

      assert %{"data" => %{"uploadFile" => "file_uploaded_succesfully"}} == body

      assert [] = Repo.all(Transaction)
    end
  end

  describe "querying company transactions" do
    @company_transactions_query """
    query {
      companyTransactions {
        balance
        ownerName
        tradingName
        transactions {
          amount
          card
          cpf
          occurredAt
          transactionType
        }
      }
    }
    """

    test "with no records", %{conn: conn} do
      body =
        conn
        |> post("/api/graphql", %{query: @company_transactions_query})
        |> json_response(200)

      assert %{"data" => %{"companyTransactions" => []}} == body
    end

    test "with records imported into database", %{conn: conn} do
      import_records_from("CNAB.txt")

      body =
        conn
        |> post("/api/graphql", %{query: @company_transactions_query})
        |> json_response(200)

      assert %{
               "data" => %{
                 "companyTransactions" => [
                   %{
                     "balance" => "-102.0",
                     "ownerName" => "JOÃO MACEDO",
                     "tradingName" => "BAR DO JOÃO"
                   },
                   %{
                     "balance" => "152.32",
                     "ownerName" => "MARIA JOSEFINA",
                     "tradingName" => "LOJA DO Ó - FILIAL"
                   },
                   %{
                     "balance" => "230.0",
                     "ownerName" => "MARIA JOSEFINA",
                     "tradingName" => "LOJA DO Ó - MATRIZ"
                   },
                   %{
                     "balance" => "489.2",
                     "ownerName" => "MARCOS PEREIRA",
                     "tradingName" => "MERCADO DA AVENIDA"
                   },
                   %{
                     "balance" => "-7023.0",
                     "ownerName" => "JOSÉ COSTA",
                     "tradingName" => "MERCEARIA 3 IRMÃOS"
                   }
                 ]
               }
             } = body
    end

    defp import_records_from(filename) do
      file_path = path_to_fixture(filename)

      file_param = %{
        path: file_path,
        filename: filename
      }

      Financial.create_transaction_from_file(file_param)
    end
  end
end
