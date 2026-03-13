# Shipping Guide

This is the practical checklist for turning this repository into a public GitHub repo and a published Railway template.

## Repository Shipping

1. Create a public GitHub repository, ideally named `gb-neo4j-railway-template`.
2. Push this repository to the default branch, preferably `main`.
3. Keep [CHANGELOG.md](/root/gb-neo4j-railway-template/CHANGELOG.md) current so Railway template update notifications are meaningful.
4. Add the Railway template button after the template is published and you have the template code.

Suggested repository metadata:

- Name: `gb-neo4j-railway-template`
- Visibility: public
- Description: `Railway-ready Neo4j template with pinned upstream image, generated auth, plugin toggles, and operator docs`
- Topics: `neo4j`, `railway`, `template`, `docker`, `graph-database`

## Railway Template Composer Checklist

Use [docs/publisher-setup.md](/root/gb-neo4j-railway-template/docs/publisher-setup.md) while configuring the template in Railway.

At minimum:

1. Create a new template from the GitHub repository.
2. Use a single service named `Neo4j`.
3. Attach one volume at `/data`.
4. Enable HTTP public networking.
5. Optionally enable a TCP Proxy on `7687` for external Bolt.
6. Add the recommended variables and descriptions.
7. Use [assets/neo4j-railway-template-icon.svg](/root/gb-neo4j-railway-template/assets/neo4j-railway-template-icon.svg) for the template icon if you do not have a branded replacement.

## Recommended Published Defaults

Use these as the visible template defaults:

- `RAILWAY_NEO4J_IMAGE_TAG=5.26.22-community-trixie`
- `NEO4J_PASSWORD=${{secret(40, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")}}`
- `NEO4J_PLUGINS_LIST=apoc`
- `NEO4J_server_memory_heap_initial__size=1G`
- `NEO4J_server_memory_heap_max__size=4G`
- `NEO4J_server_memory_pagecache_size=4G`
- `NEO4J_dbms_memory_transaction_total_max=1G`

Mention these as the smaller hobby fallback profile in the template notes or README:

- `NEO4J_server_memory_heap_initial__size=512M`
- `NEO4J_server_memory_heap_max__size=512M`
- `NEO4J_server_memory_pagecache_size=256M`
- `NEO4J_dbms_memory_transaction_total_max=128M`

## Post-Publish Tasks

After Railway assigns the template code:

1. Add a `Deploy on Railway` button to the repository README.
2. Add the live template URL to the README and repo description if useful.
3. Cut a tagged release if you want a visible source milestone.
4. Keep the root branch stable, because Railway update notifications are triggered from root-branch changes on GitHub-backed templates.

