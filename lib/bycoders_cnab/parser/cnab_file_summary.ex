defmodule BycodersCnab.Parser.CNABFileSummary do
  alias BycodersCnab.Parser.CNABLine

  @typedoc """
  Type that represents the whole CNAB file, with a list of lines parsed parsedfully,
  a list of lines with errors and a total of lines processed lines in the file.
  """

  defstruct parsed: [], with_error: [], total: 0

  @type line_with_error :: {line :: pos_integer(), error :: term()}
  @type t :: %__MODULE__{
          parsed: list(CNABLine.t()),
          with_error: list(line_with_error()),
          total: integer()
        }

  @spec new() :: t()
  def new() do
    struct!(__MODULE__, %{})
  end

  @spec new(keyword()) :: t()
  def new(fields) do
    struct!(__MODULE__, fields)
  end
end
