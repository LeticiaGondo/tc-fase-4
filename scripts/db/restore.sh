#!/usr/bin/env sh
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <backup-file.sql>" >&2
  exit 1
fi

BACKUP_FILE="$1"

: "${DB_HOST:=127.0.0.1}"
: "${DB_PORT:=3306}"
: "${DB_NAME:=feedbackdb}"
: "${DB_USER:=feedback}"
: "${DB_PASSWORD:=feedback}"

if [ ! -f "${BACKUP_FILE}" ]; then
  echo "Backup file ${BACKUP_FILE} not found" >&2
  exit 1
fi

echo "Restoring ${BACKUP_FILE} into ${DB_NAME} on ${DB_HOST}:${DB_PORT}"
MYSQL_PWD="${DB_PASSWORD}" mysql \
  -h "${DB_HOST}" \
  -P "${DB_PORT}" \
  -u "${DB_USER}" \
  "${DB_NAME}" < "${BACKUP_FILE}"

echo "Restore finished"
