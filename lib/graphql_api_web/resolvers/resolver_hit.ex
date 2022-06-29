defmodule GraphqlApiWeb.Resolvers.ResolverHit do
    @moduledoc false

  alias GraphqlApi.HitTracker

  def get_hits(%{key: key}, _) do
    HitTracker.add_hit(:RESOLVER_HITS)
    count = HitTracker.get_hits(key)
    {:ok, %{key: key, count: count}}
  end
end
