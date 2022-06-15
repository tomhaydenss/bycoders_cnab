defmodule BycodersCnab.FinancialTest do
  use BycodersCnab.DataCase

  import ExUnit.CaptureLog
  import Mox

  alias BycodersCnab.Financial
  alias BycodersCnab.Financial.Transaction
  alias BycodersCnab.Financial.TransactionType
  alias BycodersCnab.Parser.CNABFileSummary
  alias BycodersCnab.Parser.CNABLine
  alias BycodersCnab.Parser.CNABParserMock
  alias BycodersCnab.Repo

  describe "create_transaction/1" do
    @invalid_attrs %{
      amount: nil,
      card: nil,
      cpf: nil,
      occurred_at: nil,
      owner_name: nil,
      trading_name: nil,
      transaction_type: nil
    }

    test "with valid data creates a transaction" do
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

    test "with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Financial.create_transaction(@invalid_attrs)
    end
  end

  setup :verify_on_exit!

  describe "create_transaction_from_file/1" do
    test "with valid cnab file lines" do
      filename = "cnab_file.txt"
      file_path = "path/to/#{filename}"

      file_param = %{
        path: file_path,
        filename: filename
      }

      parsed_lines = [
        CNABLine.new(%{
          amount: 142.0,
          card: "4753****3153",
          cpf: "09620676017",
          date: ~D[2019-03-01],
          owner_name: "JOÃO MACEDO",
          time: ~T[15:34:53],
          trading_name: "BAR DO JOÃO",
          transaction_type: 3
        }),
        CNABLine.new(%{
          amount: 132.0,
          card: "3123****7687",
          cpf: "55641815063",
          date: ~D[2019-03-01],
          owner_name: "MARIA JOSEFINA",
          time: ~T[14:56:07],
          trading_name: "LOJA DO Ó - MATRIZ",
          transaction_type: 5
        })
      ]

      total = Enum.count(parsed_lines)

      file_parsed_result =
        CNABFileSummary.new(%{
          parsed: parsed_lines,
          total: total
        })

      CNABParserMock
      |> expect(:parse, fn ^file_path ->
        {:ok, file_parsed_result}
      end)

      log = capture_log(fn -> Financial.create_transaction_from_file(file_param) end)

      records = Repo.all(Transaction)
      assert [first, second] = records

      assert Enum.count(records) == 2
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

      assert log =~ "CNAB file #{filename} with #{total} lines in total was processed."
      assert log =~ "Lines parsed with success: #{Enum.count(parsed_lines)}."
      assert log =~ "Lines with error: 0."
    end

    test "with cnab file with invalid lines" do
      filename = "cnab_file.txt"
      file_path = "path/to/#{filename}"

      file_param = %{
        path: file_path,
        filename: filename
      }

      lines_with_errors = [
        {1, :invalid_content},
        {2, :invalid_content},
        {3, :invalid_content},
        {4, :invalid_content},
        {5, :invalid_content}
      ]

      total = Enum.count(lines_with_errors)

      file_parsed_result =
        CNABFileSummary.new(%{
          with_error: lines_with_errors,
          total: total
        })

      CNABParserMock
      |> expect(:parse, fn ^file_path ->
        {:ok, file_parsed_result}
      end)

      log = capture_log(fn -> Financial.create_transaction_from_file(file_param) end)

      assert [] = Repo.all(Transaction)

      lines_with_errors
      |> Enum.each(fn {line, error} ->
        assert log =~ "Unable to parse line #{line} from file #{filename} due to error: #{error}"
      end)

      assert log =~ "CNAB file #{filename} with #{total} lines in total was processed."
      assert log =~ "Lines parsed with success: 0."
      assert log =~ "Lines with error: #{Enum.count(lines_with_errors)}."
    end
  end

  defp random_transaction_type do
    Ecto.Enum.values(BycodersCnab.Financial.Transaction, :transaction_type)
    |> Enum.take_random(1)
    |> hd()
  end
end
