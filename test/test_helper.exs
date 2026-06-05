# TwMerge.merge/1 (used by ShadcnElixir.cn/1) requires the TwMerge.Cache process.
{:ok, _} = TwMerge.Cache.start_link([])

ExUnit.start()
