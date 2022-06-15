defmodule BycodersCnabWeb.Resolvers.Financial do
  @moduledoc """
    A context to provide financial operations
  """

  alias BycodersCnab.Financial
  alias BycodersCnabWeb.Resolvers.DTOs.CompanyTransactions

  def upload_file(_parent, args, _resolution) do
    args.file
    |> Map.from_struct()
    |> Map.take([:path, :filename])
    |> Financial.create_transaction_from_file()

    {:ok, :file_uploaded_succesfully}
  end

  def get_company_transactions(_parent, _args, _resolution) do
    company_transactions =
      [asc: :trading_name, asc: :occurred_at]
      |> Financial.get_transactions()
      |> CompanyTransactions.from_transactions()

    {:ok, company_transactions}
  end
end
