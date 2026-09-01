#!/bin/bash

# Script de backup do mundo Minecraft NasaCraft
# Uso: ./scripts/backup.sh

BACKUP_DIR="./backups"
WORLD_DIR="./world"
RETENTION_DAYS=7
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

mkdir -p "$BACKUP_DIR"

echo "💾 Iniciando backup do mundo NasaCraft..."
echo "Timestamp: $TIMESTAMP"

# Disable auto-save
echo "⏸️ Desativando auto-save..."
docker-compose exec -T minecraft-server rcon-cli save-off

# Save-all
echo "💾 Executando save-all..."
docker-compose exec -T minecraft-server rcon-cli save-all
sleep 5

# Criar backup
echo "📦 Compactando mundo..."
tar -czf "$BACKUP_DIR/nasacraft-$TIMESTAMP.tar.gz" -C "$WORLD_DIR" . 2>/dev/null

# Re-enable auto-save
echo "▶️ Reativando auto-save..."
docker-compose exec -T minecraft-server rcon-cli save-on

# Limpar backups antigos
echo "🗑️ Removendo backups anteriores a $RETENTION_DAYS dias..."
find "$BACKUP_DIR" -name "nasacraft-*.tar.gz" -mtime +$RETENTION_DAYS -delete

echo "✅ Backup concluído!"
echo "📍 Local: $BACKUP_DIR/nasacraft-$TIMESTAMP.tar.gz"
ls -lh "$BACKUP_DIR" | tail -5