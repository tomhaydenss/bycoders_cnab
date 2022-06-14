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

  @enum_operation [
    debito: :income,
    boleto: :expense,
    financiamento: :expense,
    credito: :income,
    recebimento_emprestimo: :income,
    vendas: :income,
    recebimento_ted: :income,
    recebimento_doc: :income,
    aluguel: :expense
  ]

  def values(), do: @enum_values

  def for(id) do
    Enum.find_value(@enum_values, fn {enum, key} -> if key == id, do: enum end)
  end

  def operation(enum) do
    Keyword.get(@enum_operation, enum)
  end
end
