defmodule GraphqlApiWeb.Middlewares.Authentication do
  @moduledoc false
  @behaviour Absinthe.Middleware
  @impl Absinthe.Middleware

  alias GraphqlApi.Config

  @secret_key Config.secret_key()

  @spec call(Absinthe.Resolution.t(), any) :: Absinthe.Resolution.t()
  def call(%{context: %{secret_key: secret_key}} = resolution, _) do
    case secret_key do
      @secret_key -> resolution
      _ -> Absinthe.Resolution.put_result(resolution, {:error, "unauthenticated"})
    end
  end

  def call(resolution, _) do
    Absinthe.Resolution.put_result(resolution, {:error, "Please enter a secret key"})
  end
end
