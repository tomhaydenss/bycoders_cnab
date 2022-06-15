defmodule BycodersCnab.Parser.CNABParserImpl do
  @moduledoc """
  Concret implementation of a CNABParser behaviour
  """
  @behaviour BycodersCnab.Parser.CNABParser

  alias BycodersCnab.Parser.CNABFileSummary
  alias BycodersCnab.Parser.CNABLine

  @cnab_fields [
    %{field_name: :transaction_type, starts_at: 1, ends_at: 1, length: 1, data_type: :int},
    %{field_name: :date, starts_at: 2, ends_at: 9, length: 8, data_type: :date},
    %{field_name: :amount, starts_at: 10, ends_at: 19, length: 10, data_type: :double},
    %{field_name: :cpf, starts_at: 20, ends_at: 30, length: 11, data_type: :string},
    %{field_name: :card, starts_at: 31, ends_at: 42, length: 12, data_type: :string},
    %{field_name: :time, starts_at: 43, ends_at: 48, length: 6, data_type: :time},
    %{field_name: :owner_name, starts_at: 49, ends_at: 62, length: 14, data_type: :string},
    %{field_name: :trading_name, starts_at: 63, ends_at: 81, length: 19, data_type: :string}
  ]
  @cnab_line_length 80

  @impl true
  @callback parse(file_path :: String.t()) :: {:ok, CNABFileSummary.t()} | {:error, term()}
  def parse(file_path) do
    result =
      file_path
      |> File.stream!()
      |> Enum.map(&String.trim(&1, "\n"))
      |> Enum.map(&parse_line/1)
      |> Enum.with_index()
      |> Enum.reduce(
        CNABFileSummary.new(),
        fn
          {{:ok, parsed_content}, _idx}, acc ->
            %{acc | parsed: acc.parsed ++ [parsed_content], total: acc.total + 1}

          {{:error, reason}, idx}, acc ->
            %{
              acc
              | with_error: acc.with_error ++ [{idx + 1, reason}],
                total: acc.total + 1
            }
        end
      )

    {:ok, result}
  end

  defp parse_line(line) do
    if valid_content?(line) do
      record =
        @cnab_fields
        |> Enum.map(fn field -> extract(line, field) end)
        |> CNABLine.new()

      {:ok, record}
    else
      {:error, :invalid_content}
    end
  end

  defp valid_content?(line), do: String.length(line) == @cnab_line_length

  defp extract(line, %{
         field_name: field_name,
         starts_at: starts_at,
         length: length,
         data_type: data_type
       }) do
    value =
      line
      |> String.slice(starts_at - 1, length)
      |> convert_to(data_type)

    {field_name, value}
  end

  defp convert_to(data, :string), do: String.trim(data)

  defp convert_to(data, :int), do: String.to_integer(data)

  defp convert_to(data, :double) do
    data
    |> String.to_integer()
    |> Kernel./(100)
  end

  defp convert_to(data, :date) do
    %{"day" => day, "month" => month, "year" => year} =
      Regex.named_captures(
        ~r/(?<year>[[:digit:]]{4})(?<month>[[:digit:]]{2})(?<day>[[:digit:]]{2})/,
        data
      )

    Date.from_iso8601!("#{year}-#{month}-#{day}")
  end

  defp convert_to(data, :time) do
    %{"hour" => hour, "minute" => minute, "second" => second} =
      Regex.named_captures(
        ~r/(?<hour>[[:digit:]]{2})(?<minute>[[:digit:]]{2})(?<second>[[:digit:]]{2})/,
        data
      )

    Time.from_iso8601!("#{hour}:#{minute}:#{second}")
  end
end
