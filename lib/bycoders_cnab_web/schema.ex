defmodule BycodersCnabWeb.Schema do
  use Absinthe.Schema
  alias BycodersCnabWeb.Resolvers

  import_types(Absinthe.Plug.Types)

  query do
  end

  mutation do
    @desc "Upload a file in CNAB format"
    field :upload_file, :string do
      arg(:file, non_null(:upload))
      resolve(&Resolvers.Financial.upload_file/3)
    end
  end
end
