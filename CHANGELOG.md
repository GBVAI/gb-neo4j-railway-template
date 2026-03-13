# Changelog

## 0.1.0 - 2026-03-13

- Added a pinned Neo4j Railway template based on the official upstream container, with a build-time image tag override.
- Added a Railway-aware wrapper entrypoint for password derivation, dynamic HTTP port binding, private or proxied Bolt advertising, and single-volume directory consolidation.
- Added a container healthcheck and repo-level `railway.toml`.
- Added operator documentation for template publishing, memory sizing, and plugin selection.
- Added a neutral template icon suitable for Railway template publishing.
