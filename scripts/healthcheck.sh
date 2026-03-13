#!/usr/bin/env bash
set -euo pipefail

readonly port="${PORT:-7474}"

exec 3<>"/dev/tcp/127.0.0.1/${port}"
printf 'GET / HTTP/1.0\r\nHost: 127.0.0.1\r\n\r\n' >&3
IFS= read -r status_line <&3
exec 3<&-
exec 3>&-

case "${status_line}" in
  "HTTP/1.0 200"*|"HTTP/1.1 200"*|"HTTP/1.0 302"*|"HTTP/1.1 302"*)
    exit 0
    ;;
  *)
    exit 1
    ;;
esac

