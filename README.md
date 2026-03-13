# Deploy and Host Neo4j with Railway

This repository is a single-node Neo4j template designed for Railway. It pins the upstream Neo4j container by default, lets template users override that version before launch, derives a secure `NEO4J_AUTH` from a generated password, and adapts the official image to Railway's single-volume and dynamic-port conventions.

## What This Template Optimizes For

- A pinned upstream Neo4j image with an easy build-time override through `RAILWAY_NEO4J_IMAGE_TAG`.
- Railway-friendly startup behavior for `/data`, `/logs`, `/plugins`, and `/import`.
- Safe defaults for authentication and memory, with clear overrides for heavier workloads.
- User-friendly plugin activation through `NEO4J_PLUGINS_LIST=apoc,n10s,...`.
- Minimal drift from the official Neo4j image by wrapping, not replacing, its entrypoint.

## Quick Start

1. Create a Railway template from this GitHub repository.
2. Attach a volume to the Neo4j service at `/data`.
3. Enable HTTP public networking for the Browser UI.
4. Optionally add a TCP Proxy on internal port `7687` if you want external Bolt access.
5. Define the recommended template variables from [docs/publisher-setup.md](/root/gb-neo4j-railway-template/docs/publisher-setup.md).

## Recommended Variables

The template works best when Railway prompts users for these values before deployment:

| Variable | Recommended value | Why |
| --- | --- | --- |
| `RAILWAY_NEO4J_IMAGE_TAG` | `5.26.22-community-trixie` | Pins the upstream image while still letting users override it before launch. |
| `NEO4J_PASSWORD` | `${{secret(40, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")}}` | Generates a strong initial password without asking users to handcraft `NEO4J_AUTH`. |
| `NEO4J_PLUGINS_LIST` | `apoc` | Good default for most developers; the wrapper converts this to the JSON format Neo4j expects. |
| `NEO4J_server_memory_heap_initial__size` | `1G` | Larger default initial heap for more serious app workloads. |
| `NEO4J_server_memory_heap_max__size` | `4G` | Requested default max heap. Neo4j still generally prefers equal initial and max heap in production. |
| `NEO4J_server_memory_pagecache_size` | `4G` | Larger default page cache for medium-size graphs. |
| `NEO4J_dbms_memory_transaction_total_max` | `1G` | Higher default transaction cap for imports and write-heavy use. |

The wrapper also accepts these friendly optional variables:

- `NEO4J_AUTH`: full override, for example `neo4j/my-password`. This wins over `NEO4J_PASSWORD`.
- `NEO4J_PROCEDURES_ALLOWLIST`: optional explicit procedure allowlist.
- `NEO4J_PROCEDURES_UNRESTRICTED`: optional explicit unrestricted procedures.
- `NEO4J_ENABLE_FILE_IMPORT`: sets `apoc.import.file.enabled`.
- `NEO4J_ENABLE_FILE_EXPORT`: sets `apoc.export.file.enabled`.

The previous values remain good conservative hobby defaults:

- `NEO4J_server_memory_heap_initial__size=512M`
- `NEO4J_server_memory_heap_max__size=512M`
- `NEO4J_server_memory_pagecache_size=256M`
- `NEO4J_dbms_memory_transaction_total_max=128M`

## Version Pinning

`Dockerfile` declares:

```dockerfile
ARG RAILWAY_NEO4J_IMAGE_TAG=5.26.22-community-trixie
FROM neo4j:${RAILWAY_NEO4J_IMAGE_TAG}
```

Railway makes service variables available to builds, so users can override `RAILWAY_NEO4J_IMAGE_TAG` before the first deployment without editing the repository. This keeps the template pinned by default while still giving advanced users control.

## Volume Layout

Railway supports one attached volume per service, so the wrapper consolidates the operational directories under `/data`:

- `/data` remains Neo4j's data root.
- `/plugins` is symlinked to `/data/plugins`.
- Neo4j logs are redirected to `/data/logs`.
- Neo4j imports are redirected to `/data/import`.

That means one Railway volume at `/data` preserves the database, plugin cache, import staging files, and logs.

## Networking Model

- HTTP listens on Railway's dynamic `PORT` so the Browser UI can sit behind Railway's public domain.
- Bolt listens on `7687`.
- If a TCP proxy exists, the wrapper advertises Bolt with `RAILWAY_TCP_PROXY_DOMAIN:RAILWAY_TCP_PROXY_PORT`.
- Otherwise, Bolt advertises `RAILWAY_PRIVATE_DOMAIN:7687`, which is the right default for private service-to-service traffic inside the same Railway environment.

## Memory Guidance

Use [docs/memory-sizing.md](/root/gb-neo4j-railway-template/docs/memory-sizing.md) for starter recommendations and tuning guidance. The short version:

- Keep heap initial and max equal.
- Set page cache explicitly.
- Revisit sizing once you know the actual store size and working set.
- For serious workloads, run `neo4j-admin server memory-recommendation` against real data before locking production values.

## Plugins

Use [docs/plugins.md](/root/gb-neo4j-railway-template/docs/plugins.md) for the supported plugin list, default suggestions, and security notes.

Short version:

- Start with `apoc` for utility procedures and functions.
- Add `n10s` for RDF and semantic-web use cases.
- Add `graph-data-science` only when you actually need graph algorithms and have memory headroom.
- Treat `apoc-extended`, `genai`, and `bloom` as specialized opt-ins.

To add more plugins, set `NEO4J_PLUGINS_LIST` in the Railway template or service variables:

```text
apoc
apoc,n10s
apoc,graph-data-science
apoc,n10s,graph-data-science
apoc,genai
```

The wrapper converts that comma-separated list into the JSON `NEO4J_PLUGINS` format used by the official Neo4j image.

## Files

- [Dockerfile](/root/gb-neo4j-railway-template/Dockerfile)
- [railway.toml](/root/gb-neo4j-railway-template/railway.toml)
- [scripts/entrypoint.sh](/root/gb-neo4j-railway-template/scripts/entrypoint.sh)
- [scripts/healthcheck.sh](/root/gb-neo4j-railway-template/scripts/healthcheck.sh)
- [docs/publisher-setup.md](/root/gb-neo4j-railway-template/docs/publisher-setup.md)
- [docs/memory-sizing.md](/root/gb-neo4j-railway-template/docs/memory-sizing.md)
- [docs/plugins.md](/root/gb-neo4j-railway-template/docs/plugins.md)
- [docs/shipping.md](/root/gb-neo4j-railway-template/docs/shipping.md)
- [assets/neo4j-railway-template-icon.svg](/root/gb-neo4j-railway-template/assets/neo4j-railway-template-icon.svg)
