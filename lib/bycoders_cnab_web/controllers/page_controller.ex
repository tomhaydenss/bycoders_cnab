defmodule BycodersCnabWeb.PageController do
  use BycodersCnabWeb, :controller

  # coveralls-ignore-start
  def index(conn, _params) do
    render(conn, "index.html")
  end

  # coveralls-ignore-stop
end
