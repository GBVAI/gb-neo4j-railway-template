#!/usr/bin/env bash
set -euo pipefail

readonly NEO4J_WRAPPER_NAME="railway-entrypoint"

log() {
  printf '[%s] %s\n' "${NEO4J_WRAPPER_NAME}" "$*" >&2
}

die() {
  log "ERROR: $*"
  exit 1
}

trim() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "${value}"
}

ensure_linked_dir() {
  local target_dir="$1"
  local link_path="$2"

  mkdir -p "${target_dir}"
  chown -R neo4j:neo4j "${target_dir}" || true

  if [ -L "${link_path}" ] && [ "$(readlink -f "${link_path}")" = "$(readlink -f "${target_dir}")" ]; then
    return
  fi

  if [ -e "${link_path}" ] && [ ! -L "${link_path}" ]; then
    rm -rf "${link_path}"
  fi

  ln -sfn "${target_dir}" "${link_path}"
}

configure_persistent_subdirs() {
  if [ ! -d /data ]; then
    return
  fi

  ensure_linked_dir /data/plugins /plugins

  mkdir -p /data/logs /data/import
  chown -R neo4j:neo4j /data/logs /data/import || true

  export NEO4J_server_directories_logs="${NEO4J_server_directories_logs:-/data/logs}"
  export NEO4J_server_directories_import="${NEO4J_server_directories_import:-/data/import}"
}

normalize_auth() {
  if [ -z "${NEO4J_AUTH:-}" ] && [ -n "${NEO4J_PASSWORD:-}" ]; then
    export NEO4J_AUTH="neo4j/${NEO4J_PASSWORD}"
  fi

  if [ -z "${NEO4J_AUTH:-}" ]; then
    die "Set NEO4J_PASSWORD or NEO4J_AUTH before starting Neo4j."
  fi
}

normalize_network() {
  export NEO4J_server_default__listen__address="${NEO4J_server_default__listen__address:-0.0.0.0}"
  export NEO4J_server_http_listen__address="${NEO4J_server_http_listen__address:-0.0.0.0:${PORT:-7474}}"
  export NEO4J_server_bolt_listen__address="${NEO4J_server_bolt_listen__address:-0.0.0.0:7687}"

  if [ -n "${RAILWAY_TCP_PROXY_DOMAIN:-}" ] && [ -n "${RAILWAY_TCP_PROXY_PORT:-}" ]; then
    export NEO4J_server_bolt_advertised__address="${NEO4J_server_bolt_advertised__address:-${RAILWAY_TCP_PROXY_DOMAIN}:${RAILWAY_TCP_PROXY_PORT}}"
  elif [ -n "${RAILWAY_PRIVATE_DOMAIN:-}" ]; then
    export NEO4J_server_bolt_advertised__address="${NEO4J_server_bolt_advertised__address:-${RAILWAY_PRIVATE_DOMAIN}:7687}"
  fi
}

normalize_memory() {
  export NEO4J_server_memory_heap_initial__size="${NEO4J_server_memory_heap_initial__size:-1G}"
  export NEO4J_server_memory_heap_max__size="${NEO4J_server_memory_heap_max__size:-4G}"
  export NEO4J_server_memory_pagecache_size="${NEO4J_server_memory_pagecache_size:-4G}"

  if [ -z "${NEO4J_dbms_memory_transaction_total_max:-}" ]; then
    export NEO4J_dbms_memory_transaction_total_max=1G
  fi

  if [ "${NEO4J_server_memory_heap_initial__size}" != "${NEO4J_server_memory_heap_max__size}" ]; then
    log "Heap initial and max sizes differ; Neo4j recommends setting them to the same value."
  fi
}

normalize_plugins() {
  if [ -n "${NEO4J_PLUGINS:-}" ]; then
    return
  fi

  local raw_list="${NEO4J_PLUGINS_LIST:-${NEO4J_PLUGIN_SELECTION:-}}"
  if [ -z "${raw_list}" ]; then
    return
  fi

  local normalized="${raw_list//$'\n'/,}"
  local -a tokens=()
  local -a plugins=()
  local token
  local plugin

  IFS=',' read -r -a tokens <<< "${normalized}"
  for token in "${tokens[@]}"; do
    plugin="$(trim "${token}")"
    if [ -z "${plugin}" ]; then
      continue
    fi
    plugins+=("${plugin}")
  done

  if [ "${#plugins[@]}" -eq 0 ]; then
    die "NEO4J_PLUGINS_LIST was provided but no plugin names were found."
  fi

  local json="["
  for plugin in "${plugins[@]}"; do
    json="${json}\"${plugin}\","
  done
  json="${json%,}]"

  export NEO4J_PLUGINS="${json}"
}

normalize_optional_security() {
  if [ -n "${NEO4J_PROCEDURES_ALLOWLIST:-}" ]; then
    export NEO4J_dbms_security_procedures_allowlist="${NEO4J_PROCEDURES_ALLOWLIST}"
  fi

  if [ -n "${NEO4J_PROCEDURES_UNRESTRICTED:-}" ]; then
    export NEO4J_dbms_security_procedures_unrestricted="${NEO4J_PROCEDURES_UNRESTRICTED}"
  fi

  if [ -n "${NEO4J_ENABLE_FILE_IMPORT:-}" ]; then
    export NEO4J_apoc_import_file_enabled="${NEO4J_ENABLE_FILE_IMPORT}"
  fi

  if [ -n "${NEO4J_ENABLE_FILE_EXPORT:-}" ]; then
    export NEO4J_apoc_export_file_enabled="${NEO4J_ENABLE_FILE_EXPORT}"
  fi
}

clear_helper_variables() {
  unset NEO4J_PASSWORD
  unset NEO4J_PLUGINS_LIST
  unset NEO4J_PLUGIN_SELECTION
  unset NEO4J_PROCEDURES_ALLOWLIST
  unset NEO4J_PROCEDURES_UNRESTRICTED
  unset NEO4J_ENABLE_FILE_IMPORT
  unset NEO4J_ENABLE_FILE_EXPORT
}

main() {
  configure_persistent_subdirs
  normalize_auth
  normalize_network
  normalize_memory
  normalize_plugins
  normalize_optional_security
  clear_helper_variables

  exec /startup/docker-entrypoint.sh "$@"
}

main "$@"
