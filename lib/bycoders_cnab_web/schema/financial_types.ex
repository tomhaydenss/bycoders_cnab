defmodule BycodersCnabWeb.Schema.FinancialTypes do
  @moduledoc """
    Data definitions used on GraphQL API
  """

  use Absinthe.Schema.Notation

  import_types(Absinthe.Type.Custom)

  @desc "Transaction Types"
  enum :transaction_type do
    value(:debito, description: "Débito")
    value(:boleto, description: "Boleto")
    value(:financiamento, description: "Financiamento")
    value(:credito, description: "Crédito")
    value(:recebimento_emprestimo, description: "Recebimento Empréstimo")
    value(:vendas, description: "Vendas")
    value(:recebimento_ted, description: "Recebimento TED")
    value(:recebimento_doc, description: "Recebimento DOC")
    value(:aluguel, description: "Aluguel")
  end

  @desc "Financial Transaction of a Company"
  object :transaction do
    field(:transaction_type, :transaction_type)
    field(:occurred_at, :datetime)
    field(:amount, :decimal)
    field(:cpf, :string)
    field(:card, :string)
  end

  @desc "Company informations"
  object :company do
    field(:trading_name, :string)
    field(:owner_name, :string)
    field(:balance, :decimal)
    field(:transactions, list_of(:transaction))
  end
end
