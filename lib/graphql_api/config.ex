defmodule GraphqlApi.Config do
  @moduledoc """
  Fetches the environmental variables from the config.exs file
  """

  @app :graphql_api

  @spec secret_key :: String.t()
  def secret_key do
    Application.fetch_env!(@app, :secret_key)
  end

  @spec token_max_age :: %{unit: :atom, amount: pos_integer()}
  def token_max_age do
    Application.fetch_env!(@app, :token_max_age)
  end

  @spec producer_sleep_time :: non_neg_integer()
  def producer_sleep_time do
    Application.fetch_env!(@app, :producer_sleep_time)
  end
end
