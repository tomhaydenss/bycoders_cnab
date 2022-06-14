defmodule BycodersCnab.Financial do
  @moduledoc """
  The Financial context.
  """
  require Logger

  import Ecto.Query, warn: false
  alias BycodersCnab.Repo

  alias BycodersCnab.Financial.Transaction

  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @type file :: %{
          path: String.t(),
          filename: String.t()
        }
  @spec create_transaction_from_file(file()) :: :ok
  def create_transaction_from_file(file) do
    {:ok, result} = cnab_parser().parse(file.path)
    log_cnab_file_info(file.filename, result)

    result.parsed
    |> Enum.map(&Transaction.Adapter.from_cnab_line/1)
    |> Enum.each(&create_transaction/1)

    result.with_error
    |> Enum.each(fn {line, error} ->
      Logger.error(
        "Unable to parse line #{line} from file #{file.filename} due to error: #{error}"
      )
    end)
  end

  defp cnab_parser() do
    Application.get_env(:bycoders_cnab, :cnab_parser)
  end

  defp log_cnab_file_info(filename, %{
         parsed: parsed,
         with_error: errors,
         total: total
       }) do
    Logger.info(
      "CNAB file #{filename} with #{total} lines in total was processed. Lines parsed with success: #{Enum.count(parsed)}. Lines with error: #{Enum.count(errors)}."
    )
  end
end
