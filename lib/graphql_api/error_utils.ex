defmodule GraphqlApi.ErrorUtils do
  @spec on_conflict(atom(), String.t()) :: [%{code: atom(), details: map(), message: String.t()}]
  def on_conflict(k, v) do
    [%{message: "#{k} #{v}", code: :conflict, details: %{param: k}}]
  end

  @spec internal_server_error_found(atom(), String.t()) :: [%{code: atom(), details: map(), message: String.t()}]
  def internal_server_error_found(k, v) do
    [%{message: "#{k} #{v}", code: :internal_server_error, details: %{param: k}}]
  end
end
