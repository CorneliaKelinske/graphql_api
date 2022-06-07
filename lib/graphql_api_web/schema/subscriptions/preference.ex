defmodule GraphqlApiWeb.Schema.Subscriptions.Preference do
  use Absinthe.Schema.Notation

  object :preference_subscriptions do
    field :updated_user_preferences, :preference do
      arg :user_id, non_null(:id)

      config fn args, _ -> {:ok, topic: key(args)} end

      trigger :update_user_preferences, topic: &key/1
    end
  end

  defp key(%{user_id: user_id}) do
    "user_preference_update:#{user_id}"
  end
end
