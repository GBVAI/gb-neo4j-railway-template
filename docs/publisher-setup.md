# Railway Template Publisher Setup

This repository contains the runtime pieces. The actual template prompts, descriptions, generated secrets, attached volume, and networking mode are configured in Railway's template composer.

## Recommended Service Settings

Use a single service named `Neo4j` and point it at this repository.

- Source: GitHub repository
- Root directory: repository root
- Builder: Dockerfile
- Public networking: enabled for HTTP
- TCP Proxy: optional on internal port `7687`
- Volume mount path: `/data`
- Healthcheck path: `/`

## Recommended Template Variables

Define these in the template composer so users can review or override them before deploying:

| Variable | Suggested value | Description |
| --- | --- | --- |
| `RAILWAY_NEO4J_IMAGE_TAG` | `5.26.22-community-trixie` | Pinned upstream Neo4j image tag. Users can override before launch. |
| `NEO4J_PASSWORD` | `${{secret(40, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")}}` | Strong initial password for the `neo4j` user. |
| `NEO4J_PLUGINS_LIST` | `apoc` | Friendly comma-separated plugin list. Start with APOC and add more only when needed. |
| `NEO4J_server_memory_heap_initial__size` | `1G` | Larger starter heap for app-style workloads. |
| `NEO4J_server_memory_heap_max__size` | `4G` | Requested default max heap. |
| `NEO4J_server_memory_pagecache_size` | `4G` | Larger starter page cache for medium-size graphs. |
| `NEO4J_dbms_memory_transaction_total_max` | `1G` | Higher transaction cap for imports and write-heavy workloads. |
| `NEO4J_PROCEDURES_ALLOWLIST` | empty | Optional exact procedure allowlist. |
| `NEO4J_PROCEDURES_UNRESTRICTED` | empty | Optional exact unrestricted procedures. |
| `NEO4J_ENABLE_FILE_IMPORT` | `false` | Optional APOC file import flag. |
| `NEO4J_ENABLE_FILE_EXPORT` | `false` | Optional APOC file export flag. |

## Suggested Derived Variables

These make life easier for applications deployed in the same Railway project:

| Variable | Suggested value | Notes |
| --- | --- | --- |
| `NEO4J_URI` | `neo4j://${{Neo4j.RAILWAY_PRIVATE_DOMAIN}}:7687` | Best default for private app-to-database connectivity. |
| `NEO4J_BOLT_URI` | `bolt://${{Neo4j.RAILWAY_PRIVATE_DOMAIN}}:7687` | Useful for clients that prefer `bolt://`. |
| `NEO4J_HTTP_URL` | `https://${{Neo4j.RAILWAY_PUBLIC_DOMAIN}}` | Browser UI URL. |

If you also enable a TCP proxy for external drivers:

| Variable | Suggested value | Notes |
| --- | --- | --- |
| `NEO4J_PUBLIC_BOLT_URI` | `neo4j://${{Neo4j.RAILWAY_TCP_PROXY_DOMAIN}}:${{Neo4j.RAILWAY_TCP_PROXY_PORT}}` | External Bolt entrypoint. |

## Recommended User-Facing Descriptions

These are good short descriptions for the template composer:

- `RAILWAY_NEO4J_IMAGE_TAG`: "Pinned Neo4j container tag. Override only if you need a different supported upstream version."
- `NEO4J_PASSWORD`: "Initial password for the neo4j user. Automatically generated with a strong secret."
- `NEO4J_PLUGINS_LIST`: "Comma-separated plugin names such as apoc,n10s,graph-data-science."
- `NEO4J_server_memory_heap_initial__size`: "JVM heap start size. Neo4j often prefers equal min and max heap, but this template defaults to 1G."
- `NEO4J_server_memory_heap_max__size`: "JVM heap max size. Neo4j often prefers equal min and max heap, but this template defaults to 4G."
- `NEO4J_server_memory_pagecache_size`: "Page cache for graph files. Increase as the graph store grows."
- `NEO4J_dbms_memory_transaction_total_max`: "Optional cap for transaction memory spikes."

If you want to expose conservative hobby defaults in the template description or advanced notes, document these values as the smaller alternative profile:

- `512M` heap initial
- `512M` heap max
- `256M` page cache
- `128M` transaction cap

## Suggested Marketplace Overview

Use this as a starting point for the Railway template overview:

## Deploy and Host Neo4j with Railway

Neo4j is a graph database built for connected data, relationship-heavy queries, graph APIs, recommendation engines, knowledge graphs, and graph-assisted AI workloads. This template packages Neo4j for Railway with version pinning, generated authentication, a persistent volume strategy, and practical knobs for memory and plugins.

## About Hosting Neo4j

Running Neo4j well means getting a few things right early: persistent storage, a fixed heap, explicit page cache sizing, and a decision about whether Bolt should stay private or be exposed with a TCP proxy. This template keeps the runtime close to the official Neo4j container while adapting it to Railway's dynamic HTTP port and one-volume-per-service model.

## Common Use Cases

- Knowledge graphs and graph-enhanced retrieval
- Recommendations, fraud, and identity graphs
- Metadata graphs for internal tools and SaaS products
- RDF and semantic-web workloads with `n10s`
- Algorithm-heavy graph applications with Graph Data Science

## Dependencies for Neo4j Hosting

- Neo4j official Docker image
- Railway volume storage
- Railway private networking
- Optional Railway TCP Proxy for external Bolt access

### Deployment Dependencies

- Neo4j Operations Manual
- Neo4j APOC documentation
- Railway template documentation

### Why Deploy Neo4j on Railway?

Railway gives Neo4j a clean deployment path without forcing users to manage a full VM. Template users can start with generated credentials, attach persistent storage, keep application traffic on Railway private networking, and scale memory settings as their data grows.
