#!/usr/bin/env bash
set -euo pipefail

CONNECT_URL="${CONNECT_URL:-http://localhost:8083}"

echo "[connect] Waiting for Kafka Connect on ${CONNECT_URL}..."
until curl -sf "${CONNECT_URL}/connectors" >/dev/null 2>&1; do
  sleep 2
done

echo "[connect] Registering messages-jdbc-sink connector..."
curl -sf -X POST "${CONNECT_URL}/connectors" \
  -H "Content-Type: application/json" \
  -d @docker/kafka-connect/connector.json

echo
echo "[connect] Connector registered. Check status with: curl ${CONNECT_URL}/connectors/messages-jdbc-sink/status"
