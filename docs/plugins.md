# Plugin Guide

Neo4j supports plugin installation with the `NEO4J_PLUGINS` environment variable. This repository adds a friendlier `NEO4J_PLUGINS_LIST` variable so template users can enable multiple plugins with a comma-separated list such as:

```text
apoc,n10s,graph-data-science
```

The wrapper converts that into the JSON array the official image expects.

## What Is APOC?

APOC is Neo4j's library of extra procedures and functions. It is the most common first plugin because it adds a large set of utility operations for data cleanup, refactoring, exports, imports, path work, date and map helpers, and other day-to-day graph tasks that are awkward or verbose in plain Cypher alone.

## Recommended Defaults

Start with:

```text
NEO4J_PLUGINS_LIST=apoc
```

Then opt into more plugins only when your use case clearly needs them.

## How To Add More Plugins

Set `NEO4J_PLUGINS_LIST` to a comma-separated list in Railway:

```text
apoc
apoc,n10s
apoc,graph-data-science
apoc,n10s,graph-data-science
apoc,genai
apoc,apoc-extended
```

You can do that either:

- In the template composer, as the default value users can override before launch.
- In a deployed Railway service, by editing the service variables and redeploying.

## Supported Plugin Names

The official Neo4j Docker image currently recognizes these plugin names:

- `apoc`
- `apoc-extended`
- `bloom`
- `genai`
- `graph-data-science`
- `n10s`

## Suggested Use

| Plugin | Good default? | Use it for | Notes |
| --- | --- | --- | --- |
| `apoc` | Yes | extra procedures and functions for common graph tasks | Best default for most developers. |
| `n10s` | Sometimes | RDF, OWL, SHACL, semantic-web interoperability | Good add-on for linked-data projects. |
| `graph-data-science` | Only when needed | graph algorithms, embeddings pipelines, similarity, recommendations | Memory-hungry compared with a plain OLTP graph. |
| `genai` | Specialized | LLM and provider integrations | Usually needs external API keys and egress. |
| `apoc-extended` | Specialized | a larger and more permissive APOC surface | Treat as an advanced opt-in. |
| `bloom` | Rare in this template | browser-based graph visualization | Usually relevant only for enterprise-oriented setups. |

## Security Notes

- Do not start with a broad unrestricted procedure rule unless you actually need it.
- Prefer exact or narrow values in `NEO4J_PROCEDURES_ALLOWLIST` and `NEO4J_PROCEDURES_UNRESTRICTED`.
- Enable APOC file import or export only if your workload needs it.

Example:

```text
NEO4J_PLUGINS_LIST=apoc,n10s
NEO4J_PROCEDURES_UNRESTRICTED=apoc.*
NEO4J_ENABLE_FILE_IMPORT=true
```

## Production Note

The official `NEO4J_PLUGINS` downloader is excellent for convenience, but it is still a runtime plugin installer. For high-control production environments, prefer vendoring or pre-baking the exact plugin jars you depend on.
