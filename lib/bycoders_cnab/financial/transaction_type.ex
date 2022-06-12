defmodule BycodersCnab.Financial.TransactionType do
  @enum_values [
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

  def values(), do: @enum_values
end
