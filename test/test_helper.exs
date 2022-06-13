ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(BycodersCnab.Repo, :manual)

defmodule BycodersCnab.TestHelpers do
  def path_to_fixture(name), do: "test/fixtures/#{name}"
end
