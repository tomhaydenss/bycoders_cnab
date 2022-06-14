defmodule BycodersCnabWeb.Resolvers.Financial do
  alias BycodersCnab.Financial

  def upload_file(_parent, args, _resolution) do
    args.file
    |> Map.from_struct()
    |> Map.take([:path, :filename])
    |> Financial.create_transaction_from_file()

    {:ok, :file_uploaded_succesfully}
  end
end
