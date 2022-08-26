defmodule GraphqlApiWeb.AuthPlug do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do

    case get_req_header(conn, "authentication") do
      [] -> conn
      secret_key  -> Absinthe.Plug.put_options(conn, context: %{secret_key: List.first(secret_key)})
    end

  end
end
