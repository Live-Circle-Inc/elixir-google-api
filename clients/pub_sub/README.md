# ega_pub_sub

Cloud Pub/Sub API client library — Live Circle's maintained fork of
[`google_api_pub_sub`](https://hex.pm/packages/google_api_pub_sub).

Provides reliable, many-to-many, asynchronous messaging between applications.

This is a **drop-in replacement**: the module namespace is unchanged
(`GoogleApi.PubSub.V1.*`) and the generated API is upstream's 0.42.0. Only the
package name differs, and it depends on
[`ega_gax`](https://hex.pm/packages/ega_gax) instead of
`google_gax`.

## Why this fork exists

Upstream [`googleapis/elixir-google-api`](https://github.com/googleapis/elixir-google-api)
has been **formally archived**. The blocking problem was not in the generated
code but in `google_gax`, which no longer works with current Tesla: it passed no
`:max_body_size` to `Tesla.Middleware.DecompressResponse`, so on Tesla >= 1.18.3
every Pub/Sub call raised `ArgumentError` while decompressing the response —
after the request had already been sent. See
[`ega_gax`](https://hex.pm/packages/ega_gax) for the full list of
fixes.

## Installation

```elixir
def deps do
  [
    {:ega_pub_sub, "~> 0.42"}
  ]
end
```

`ega_gax` arrives transitively. Migrating from `google_api_pub_sub`: swap
the dependency name — no code changes are required.

Note the configuration key follows the app name, so the base-URL override is:

```elixir
config :ega_pub_sub, base_url: "http://localhost:8085"
```

## For more information

Product documentation is available at [https://cloud.google.com/pubsub/docs](https://cloud.google.com/pubsub/docs).

## License

Apache-2.0, inherited from upstream. See [LICENSE](./LICENSE).
