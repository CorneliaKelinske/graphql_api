defmodule GraphqlApiWeb.Resolvers.ResolverHit do
  @moduledoc false

  alias GraphqlApi.HitCounter

  @type resolution :: Absinthe.Resolution.t()
  @type request :: HitCounter.request()

  @spec get_hits(%{key: request()}, resolution()) ::
          {:ok, %{key: request(), count: non_neg_integer()}}
  def get_hits(%{key: key}, _) do
    HitCounter.add_hit(:resolver_hits)
    count = HitCounter.get_hits(key)
    {:ok, %{key: key, count: count}}
  end
end
