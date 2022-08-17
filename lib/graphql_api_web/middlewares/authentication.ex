defmodule GraphqlApiWeb.Middlewares.Authentication do
  @behaviour Absinthe.Middleware
  @impl Absinthe.Middleware


  def call(resolution, _) do

    case secret_key() do
    "Imsecret" -> resolution
      _ -> Absinthe.Resolution.put_result(resolution, {:error, "unauthenticated"})
    end
  end

  defp secret_key do
    Application.get_env(:graphql_api, :secret_key)
  end
end
