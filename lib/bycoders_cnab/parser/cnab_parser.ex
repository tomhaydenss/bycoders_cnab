defmodule BycodersCnab.Parser.CNABParser do
  @moduledoc """
  A behaviour to parse CNAB files
  """
  alias BycodersCnab.Parser.CNABFileSummary

  @callback parse(file_path :: String.t()) :: {:ok, CNABFileSummary.t()} | {:error, term()}
end
