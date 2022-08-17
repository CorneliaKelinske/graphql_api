defmodule GraphqlApiWeb.Middlewares.HandleErrors do
  @moduledoc false
  alias GraphqlApi.ErrorUtils
  @behaviour Absinthe.Middleware

  @impl Absinthe.Middleware

  @spec call(Absinthe.Resolution.t(), any) :: Absinthe.Resolution.t()
  def call(resolution, _) do
    %{resolution | errors: Enum.flat_map(resolution.errors, &handle_error/1)}
  end

  defp handle_error(%Ecto.Changeset{} = changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {err, _opts} -> err end)
    |> Enum.flat_map(fn {k, v} -> [k, v] end)
    |> turn_into_tuple()
    |> get_error_message()
  end

  defp handle_error(%ErrorMessage{message: message, code: code, details: details}) do
    [%{message: message, code: code, details: details}]
  end

  defp handle_error(error), do: [error]

  defp turn_into_tuple([k | [v]]) do
    {k, List.first(v)}
  end

  defp get_error_message({k, v}) when v === "has already been taken" do
    ErrorUtils.on_conflict(k, v)
  end

  defp get_error_message({k, v}) do
    ErrorUtils.internal_server_error_found(k, v)
  end
end
