defmodule GraphqlApi.ErrorUtils do
  @moduledoc """
  Standardizes errors returned from
  the GraphQL API
  """

  @spec conflict(String.t(), map()) :: %{code: :not_found, details: map(), message: String.t()}
  def conflict(message, details) do
    %{
      code: :not_found,
      message: message,
      details: details
    }
  end

  @spec bad_request(String.t(), map()) :: %{code: :bad_request, details: map(), message: String.t()}
  def bad_request(message, details) do
    %{
      code: :bad_request,
      message: message,
      details: details
    }
  end

  @spec internal_server_error(String.t(), map()) :: %{code: :internal_server_error, details: map(), message: String.t()}
  def internal_server_error(message, details) do
    %{
      code: :internal_server_error,
      message: message,
      details: details
    }
  end
end
