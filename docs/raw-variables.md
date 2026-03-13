# Neo4j Railway Raw Variables

Use the block below in Railway's raw variables editor for the shipped template defaults.

```dotenv
RAILWAY_NEO4J_IMAGE_TAG=5.26.22-community-trixie
NEO4J_PASSWORD=${{secret(40, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")}}
NEO4J_PLUGINS_LIST=apoc
NEO4J_server_memory_heap_initial__size=1G
NEO4J_server_memory_heap_max__size=4G
NEO4J_server_memory_pagecache_size=4G
NEO4J_dbms_memory_transaction_total_max=1G
```

## Smaller Hobby Profile

```dotenv
RAILWAY_NEO4J_IMAGE_TAG=5.26.22-community-trixie
NEO4J_PASSWORD=${{secret(40, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")}}
NEO4J_PLUGINS_LIST=apoc
NEO4J_server_memory_heap_initial__size=512M
NEO4J_server_memory_heap_max__size=512M
NEO4J_server_memory_pagecache_size=256M
NEO4J_dbms_memory_transaction_total_max=128M
```

## Plugin Variants

### APOC + n10s

```dotenv
RAILWAY_NEO4J_IMAGE_TAG=5.26.22-community-trixie
NEO4J_PASSWORD=${{secret(40, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")}}
NEO4J_PLUGINS_LIST=apoc,n10s
NEO4J_server_memory_heap_initial__size=1G
NEO4J_server_memory_heap_max__size=4G
NEO4J_server_memory_pagecache_size=4G
NEO4J_dbms_memory_transaction_total_max=1G
```

### APOC + Graph Data Science

```dotenv
RAILWAY_NEO4J_IMAGE_TAG=5.26.22-community-trixie
NEO4J_PASSWORD=${{secret(40, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")}}
NEO4J_PLUGINS_LIST=apoc,graph-data-science
NEO4J_server_memory_heap_initial__size=1G
NEO4J_server_memory_heap_max__size=4G
NEO4J_server_memory_pagecache_size=4G
NEO4J_dbms_memory_transaction_total_max=1G
```

### APOC + n10s + Graph Data Science

```dotenv
RAILWAY_NEO4J_IMAGE_TAG=5.26.22-community-trixie
NEO4J_PASSWORD=${{secret(40, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")}}
NEO4J_PLUGINS_LIST=apoc,n10s,graph-data-science
NEO4J_server_memory_heap_initial__size=1G
NEO4J_server_memory_heap_max__size=4G
NEO4J_server_memory_pagecache_size=4G
NEO4J_dbms_memory_transaction_total_max=1G
```

## Optional Advanced Toggles

Add these only when needed:

```dotenv
NEO4J_PROCEDURES_ALLOWLIST=apoc.*
NEO4J_PROCEDURES_UNRESTRICTED=apoc.*
NEO4J_ENABLE_FILE_IMPORT=true
NEO4J_ENABLE_FILE_EXPORT=true
```
