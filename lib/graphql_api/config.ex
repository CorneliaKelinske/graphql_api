defmodule GraphqlApi.Config do
  @moduledoc """
  Fetches the environmental variables from the config.exs file
  """

  @app :graphql_api

  @spec secret_key :: String.t()
  def secret_key do
    Application.fetch_env!(@app, :secret_key)
  end
end
