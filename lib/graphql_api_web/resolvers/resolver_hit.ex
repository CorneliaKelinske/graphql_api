defmodule GraphqlApiWeb.Resolvers.ResolverHit do
  @moduledoc false

  alias GraphqlApi.HitTracker

  @type resolution :: Absinthe.Resolution.t()
  @type request :: HitTracker.request()

  @spec get_hits(%{key: request()}, resolution()) ::
          {:ok, %{key: request(), count: non_neg_integer()}}
  def get_hits(%{key: key}, _) do
    HitTracker.add_hit(:RESOLVER_HITS)
    count = HitTracker.get_hits(key)
    {:ok, %{key: key, count: count}}
  end
end
