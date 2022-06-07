defmodule GraphqlApiWeb.Schema.Subscriptions.Preference do
  use Absinthe.Schema.Notation

  object :preference_subscriptions do
    field :updated_user_preferences, :preference do
      arg :user_id, non_null(:id)

      config fn args, _ ->
        {:ok, topic: args.user_id}
      end

      trigger :update_user_preferences,
        topic: fn preference ->
          preference.user_id
        end
    end
  end
end
