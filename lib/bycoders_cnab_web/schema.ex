defmodule BycodersCnabWeb.Schema do
  use Absinthe.Schema
  alias BycodersCnabWeb.Resolvers

  import_types(Absinthe.Plug.Types)
  import_types(BycodersCnabWeb.Schema.FinancialTypes)

  query do
    @desc "Company transactions"
    field :company_transactions, list_of(:company) do
      resolve(&Resolvers.Financial.get_company_transactions/3)
    end
  end

  mutation do
    @desc "Upload a file in CNAB format"
    field :upload_file, :string do
      arg(:file, non_null(:upload))
      resolve(&Resolvers.Financial.upload_file/3)
    end
  end
end
