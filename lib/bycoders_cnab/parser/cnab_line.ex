defmodule BycodersCnab.Parser.CNABLine do
  defstruct ~w[transaction_type date amount cpf card time owner_name trading_name]a

  @typedoc """
    Type that represents a line of CNAB file.
  """

  @type t :: %__MODULE__{
          transaction_type: pos_integer(),
          date: Date.t(),
          amount: float(),
          cpf: String.t(),
          card: String.t(),
          time: Time.t(),
          owner_name: String.t(),
          trading_name: String.t()
        }

  @spec new(keyword()) :: t()
  def new(fields) do
    struct!(__MODULE__, fields)
  end
end
