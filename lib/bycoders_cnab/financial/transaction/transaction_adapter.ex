defmodule BycodersCnab.Financial.Transaction.Adapter do
  @moduledoc """
    Converts a CNAB File struct into Transaction ecto schema
  """

  alias BycodersCnab.Parser.CNABLine

  @spec from_cnab_line(cnab_line :: CNABLine.t()) :: map()
  def from_cnab_line(cnab_line) do
    cnab_line
    |> Map.from_struct()
    |> Map.put(:occurred_at, get_datetime(cnab_line))
    |> Map.delete(:date)
    |> Map.delete(:time)
  end

  defp get_datetime(%{date: date, time: time}) do
    timezone = Application.get_env(:bycoders_cnab, :default_time_zone)
    date_iso8601 = Date.to_iso8601(date)
    time_iso8601 = Time.to_iso8601(time)
    {:ok, datetime, _} = DateTime.from_iso8601("#{date_iso8601} #{time_iso8601}Z")
    {:ok, datetime_with_timezone} = DateTime.shift_zone(datetime, timezone)
    datetime_with_timezone
  end
end
