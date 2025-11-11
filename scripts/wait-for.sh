#!/usr/bin/env sh
set -e

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 host port [-- command]" >&2
  exit 1
fi

HOST="$1"
PORT="$2"
shift 2

export HOST PORT

TIMEOUT="${TIMEOUT:-60}"
INTERVAL=2
START=$(date +%s)

check_nc() {
  if command -v nc >/dev/null 2>&1; then
    nc -z "$HOST" "$PORT" >/dev/null 2>&1
    return $?
  fi
  return 125
}

check_python() {
  if command -v python3 >/dev/null 2>&1; then
    python3 - <<'PYEOF'
import os
import socket
host = os.environ['HOST']
port = int(os.environ['PORT'])
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
    sock.settimeout(1)
    sock.connect((host, port))
PYEOF
    return $?
  fi
  return 125
}

while true; do
  if check_nc || check_python; then
    break
  fi
  NOW=$(date +%s)
  if [ $((NOW - START)) -ge "$TIMEOUT" ]; then
    echo "Timeout after ${TIMEOUT}s waiting for ${HOST}:${PORT}" >&2
    exit 1
  fi
  sleep "$INTERVAL"
done

if [ "$#" -gt 0 ] && [ "$1" = "--" ]; then
  shift
fi

if [ "$#" -gt 0 ]; then
  exec "$@"
fi
