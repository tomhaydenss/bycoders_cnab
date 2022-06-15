defmodule BycodersCnab.Financial.TransactionTypeTest do
  use ExUnit.Case, async: true

  alias BycodersCnab.Financial.TransactionType

  describe "values/1" do
    test "should parse a valid cnab file" do
      expected_result = [
        debito: 1,
        boleto: 2,
        financiamento: 3,
        credito: 4,
        recebimento_emprestimo: 5,
        vendas: 6,
        recebimento_ted: 7,
        recebimento_doc: 8,
        aluguel: 9
      ]

      assert expected_result == TransactionType.values()
    end
  end

  describe "for/1" do
    test "should return enum for a given id" do
      assert :debito = TransactionType.for(1)
    end
  end

  describe "operation/1" do
    test "should return a operation for a given enum" do
      assert :income = TransactionType.operation(:debito)
    end
  end
end
