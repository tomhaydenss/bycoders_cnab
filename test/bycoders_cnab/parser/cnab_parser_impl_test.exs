defmodule BycodersCnab.Parser.CNABParserImplTest do
  use ExUnit.Case, async: true

  import BycodersCnab.TestHelpers

  alias BycodersCnab.Parser.CNABParserImpl
  alias BycodersCnab.Parser.CNABFileSummary
  alias BycodersCnab.Parser.CNABLine

  describe "parse/1" do
    test "should parse a valid cnab file" do
      valid_file = path_to_fixture("valid_cnab_file.txt")

      parsed_lines = [
        CNABLine.new(%{
          amount: 142.0,
          card: "4753****3153",
          cpf: "09620676017",
          date: ~D[2019-03-01],
          owner_name: "JOÃO MACEDO",
          time: ~T[15:34:53],
          trading_name: "BAR DO JOÃO",
          transaction_type: 3
        }),
        CNABLine.new(%{
          amount: 132.0,
          card: "3123****7687",
          cpf: "55641815063",
          date: ~D[2019-03-01],
          owner_name: "MARIA JOSEFINA",
          time: ~T[14:56:07],
          trading_name: "LOJA DO Ó - MATRIZ",
          transaction_type: 5
        }),
        CNABLine.new(%{
          amount: 122.0,
          card: "6777****1313",
          cpf: "84515254073",
          date: ~D[2019-03-01],
          owner_name: "MARCOS PEREIRA",
          time: ~T[17:27:12],
          trading_name: "MERCADO DA AVENIDA",
          transaction_type: 3
        }),
        CNABLine.new(%{
          amount: 602.0,
          card: "6777****1313",
          cpf: "23270298056",
          date: ~D[2019-03-01],
          owner_name: "JOSÉ COSTA",
          time: ~T[17:27:12],
          trading_name: "MERCEARIA 3 IRMÃOS",
          transaction_type: 3
        })
      ]

      expected_parsed_file =
        CNABFileSummary.new(%{
          parsed: parsed_lines,
          total: 4,
          with_error: []
        })

      assert {:ok, expected_parsed_file} == CNABParserImpl.parse(valid_file)
    end

    test "should not parse a file different from cnab format" do
      invalid_file = path_to_fixture("invalid_cnab_file.txt")

      expected_lines_with_errors = [
        {1, :invalid_content},
        {2, :invalid_content},
        {3, :invalid_content},
        {4, :invalid_content},
        {5, :invalid_content}
      ]

      assert {:ok,
              CNABFileSummary.new(%{
                parsed: [],
                total: 5,
                with_error: expected_lines_with_errors
              })} == CNABParserImpl.parse(invalid_file)
    end
  end
end
