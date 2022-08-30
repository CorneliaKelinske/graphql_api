defmodule GraphqlApiWeb.AuthPlug do
  @moduledoc """
  Implements authentication for mutations via the http header.
  """
  @behaviour Plug

  import Plug.Conn

  @spec init(Plug.opts()) :: Plug.opts()
  def init(opts), do: opts

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _) do
    case get_req_header(conn, "authentication") do
      [] ->
        conn

      secret_key ->
        Absinthe.Plug.put_options(conn, context: %{secret_key: List.first(secret_key)})
    end
  end
end
