defmodule BycodersCnab.Parser.CNABParser do
  alias BycodersCnab.Parser.CNABFileSummary

  @callback parse(file_path :: String.t()) :: {:ok, CNABFileSummary.t()} | {:error, term()}
end
