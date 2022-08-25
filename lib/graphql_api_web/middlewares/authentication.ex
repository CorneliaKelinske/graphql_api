defmodule GraphqlApiWeb.Middlewares.Authentication do
  @behaviour Absinthe.Middleware
  @impl Absinthe.Middleware

  def call(%{context: %{secret_key: secret_key}} = resolution, _) do
    case secret_key do
     
      "TwoCanKeepASecretIfOneOfThemIsDead" -> resolution
      "not_found" -> Absinthe.Resolution.put_result(resolution, {:error, "Please enter a secret key"})
      _ -> Absinthe.Resolution.put_result(resolution, {:error, "unauthenticated"})
    end
  end


end
