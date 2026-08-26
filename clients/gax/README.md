# ega_gax

Google API Extensions for Elixir — Live Circle's maintained fork of
[`google_gax`](https://hex.pm/packages/google_gax).

This package provides the shared runtime (connection, request/response handling,
model base) used by the generated `GoogleApi.*` client libraries. It is a
**drop-in replacement** for `google_gax`: the module namespace is unchanged
(`GoogleApi.Gax.*`), only the package name differs.

## Why this fork exists

Upstream [`GoogleCloudPlatform/elixir-google-api`](https://github.com/GoogleCloudPlatform/elixir-google-api)
has been **formally archived**, and `google_gax`'s last release was 0.4.1 in
2021. It no longer works with current Tesla:

* **Tesla >= 1.18.3 broke every request.** `google_gax` installed
  `plug(Tesla.Middleware.DecompressResponse, [])` with no options, but Tesla
  made `:max_body_size` mandatory (the decompression-bomb guard from
  CVE-2026-48594). Every call through a generated client raised
  `ArgumentError` — and raised while decompressing the *response*, so the
  request had already been sent before the caller crashed. The cap is now
  passed, and is configurable per `otp_app`:

  ```elixir
  config :my_otp_app, max_body_size: 64 * 1024 * 1024
  ```

  It defaults to 32 MiB.

* **Tesla's RFC 7230 hardening broke multipart uploads.** `Tesla.Multipart`
  now requires binary field names and header keys; `google_gax` passed atoms.

* **`{:mime, "~> 1.0"}` held every dependent two majors behind.** The
  requirement was never used — there is no reference to `MIME` anywhere in the
  library — so it has been dropped. `mime` now resolves from its real
  consumers (`tesla`, `finch`), which accept 1.x or 2.x.

* **`{:poison, ">= 3.0.0 and < 5.0.0"}` was conservative, not necessary.**
  Relaxed to `< 7.0.0`. Poison 5 dropped `Poison.Decode.decode/2`, but this
  library only needs `Poison.Decode.transform/2` (its `ModelBase` already
  branches on `function_exported?/3`), plus `Poison.Encoder.encode/2`, the
  `Poison.Decoder` protocol, and `decode/2`'s `:as` option — all still present
  in Poison 6.

## Installation

```elixir
def deps do
  [
    {:ega_gax, "~> 0.5"}
  ]
end
```

Migrating from `google_gax`: swap the dependency name. No code changes are
required, since the modules are still `GoogleApi.Gax.*`. If another dependency
pulls in `google_gax` as well, add `override: true` — two packages defining the
same modules will otherwise conflict.

## Usage

This package is used to share common code between all of the Google Elixir
client libraries. It is not usually depended on directly.

## License

Apache-2.0, inherited from upstream. See [LICENSE](./LICENSE).
