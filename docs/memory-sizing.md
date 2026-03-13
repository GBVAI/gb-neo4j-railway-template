# Memory Sizing Guide

Neo4j's official guidance is to set heap and page cache explicitly, keep heap initial and max equal, and use `neo4j-admin server memory-recommendation` when you have a representative dataset. This guide adds practical starter profiles for Railway users.

## Core Rules

- Keep `NEO4J_server_memory_heap_initial__size` and `NEO4J_server_memory_heap_max__size` equal.
- Treat page cache as the memory budget for your hot graph store and indexes.
- Leave room for the OS, query execution, and plugin overhead.
- Re-tune after imports, indexing, or plugin changes.

## Starter Profiles

These are operator-friendly starting points, not hard limits.

| Profile | Typical use case | Rough data scale | Heap | Page cache | Transaction cap |
| --- | --- | --- | --- | --- | --- |
| Hobby | prototypes, personal knowledge graphs, internal tools | tens of MB to a few hundred MB on disk, or up to low hundreds of thousands of lightweight nodes | `512M` | `256M` to `512M` | `128M` |
| App | production SaaS features, recommendation graphs, moderate APIs | a few hundred MB to low single-digit GB on disk, often hundreds of thousands to a few million nodes depending on properties and indexes | `1G` to `2G` | `1G` to `4G` | `256M` to `512M` |
| Extreme | heavy analytics, graph algorithms, dense or property-rich graphs, vector-heavy graph apps | multi-GB to tens of GB on disk, hot working sets that no longer fit comfortably in a small page cache | `4G` to `16G+` | `8G` to `32G+` | `512M` to `2G` |

## How To Think About Data Size

Node count alone is a bad sizing metric. A graph with 500,000 nodes and many properties or indexes can use more memory than a graph with several million sparse nodes.

Look at these instead:

- The on-disk store size under `/data`.
- The size of your indexes and vector indexes.
- Whether your workload repeatedly touches the same subgraph or scans a large percentage of the graph.
- Whether you use memory-hungry plugins such as Graph Data Science.

## Railway-Specific Guidance

For small Railway deployments, start conservative:

- `512M` heap
- `256M` page cache
- `128M` transaction cap

Then increase in this order:

1. Increase page cache if queries repeatedly hit disk and the graph store is larger than the cache.
2. Increase heap if you see GC pressure, query planning pressure, or plugin workloads that need more JVM memory.
3. Increase the transaction cap only if large imports or writes legitimately need it.

## When To Revisit Your Defaults

Re-size memory when any of these become true:

- The graph store no longer fits comfortably in the page cache you allocated.
- Import jobs or large writes fail under transaction-memory pressure.
- Graph Data Science or APOC-heavy jobs push heap usage close to the limit.
- Query latency changes sharply after your data volume or index count grows.

## Practical Defaults For This Template

The repository starts with:

- `NEO4J_server_memory_heap_initial__size=1G`
- `NEO4J_server_memory_heap_max__size=4G`
- `NEO4J_server_memory_pagecache_size=4G`
- `NEO4J_dbms_memory_transaction_total_max=1G`

Those defaults are intentionally more generous than the original hobby profile so the template is ready for app-style workloads out of the box.

If you want the older smaller baseline, these are still good hobby defaults:

- `NEO4J_server_memory_heap_initial__size=512M`
- `NEO4J_server_memory_heap_max__size=512M`
- `NEO4J_server_memory_pagecache_size=256M`
- `NEO4J_dbms_memory_transaction_total_max=128M`
