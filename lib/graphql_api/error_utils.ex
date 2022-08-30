defmodule GraphqlApi.ErrorUtils do
  @moduledoc """
  Standardizes errors returned from
  the GraphQL API
  """

  @type response(code) :: %{code: code, details: map(), message: String.t()}

  @spec conflict(String.t(), map()) :: response(:conflict)
  def conflict(message, details) do
    %{
      code: :conflict,
      message: message,
      details: details
    }
  end

  @spec bad_request(String.t(), map()) :: response(:bad_request)
  def bad_request(message, details) do
    %{
      code: :bad_request,
      message: message,
      details: details
    }
  end

  @spec internal_server_error(String.t(), map()) :: response(:internal_server_error)
  def internal_server_error(message, details) do
    %{
      code: :internal_server_error,
      message: message,
      details: details
    }
  end
end
