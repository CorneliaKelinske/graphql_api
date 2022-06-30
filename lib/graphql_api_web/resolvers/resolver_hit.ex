defmodule GraphqlApiWeb.Resolvers.ResolverHit do
  @moduledoc false

  alias GraphqlApi.HitTracker

  @type resolution :: Absinthe.Resolution.t()

  @spec get_hits(%{:key => atom(), optional(any) => any}, resolution()) ::
          {:ok, %{count: integer(), key: atom()}}
  def get_hits(%{key: key}, _) do
    HitTracker.add_hit(:RESOLVER_HITS)
    count = HitTracker.get_hits(key)
    {:ok, %{key: key, count: count}}
  end
end
