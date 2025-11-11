#!/usr/bin/env sh
set -euo pipefail

: "${DB_HOST:=127.0.0.1}"
: "${DB_PORT:=3306}"
: "${DB_NAME:=feedbackdb}"
: "${DB_USER:=feedback}"
: "${DB_PASSWORD:=feedback}"

OUTPUT_FILE=${1:-"backup_$(date +%Y%m%d_%H%M%S).sql"}

echo "Creating backup for ${DB_NAME} on ${DB_HOST}:${DB_PORT}"
MYSQL_PWD="${DB_PASSWORD}" mysqldump \
  -h "${DB_HOST}" \
  -P "${DB_PORT}" \
  -u "${DB_USER}" \
  --single-transaction \
  --routines \
  "${DB_NAME}" > "${OUTPUT_FILE}"

echo "Backup written to ${OUTPUT_FILE}"
