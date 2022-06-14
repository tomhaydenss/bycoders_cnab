ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(BycodersCnab.Repo, :manual)

Mox.defmock(BycodersCnab.Parser.CNABParserMock, for: BycodersCnab.Parser.CNABParser)

defmodule BycodersCnab.TestHelpers do
  def path_to_fixture(name), do: "test/fixtures/#{name}"
end
