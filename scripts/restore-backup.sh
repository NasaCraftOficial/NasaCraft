#!/bin/bash

# Script de restauração de backup do mundo Minecraft
# Uso: ./scripts/restore-backup.sh <arquivo_backup>

if [ -z "$1" ]; then
    echo "❌ Uso: ./scripts/restore-backup.sh <arquivo_backup>"
    echo ""
    echo "Backups disponíveis:"
    ls -lh ./backups/nasacraft-*.tar.gz 2>/dev/null | awk '{print $NF}'
    exit 1
fi

BACKUP_FILE="$1"
WORLD_DIR="./world"

if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ Arquivo não encontrado: $BACKUP_FILE"
    exit 1
fi

echo "⚠️ AVISO: Isso vai sobrescrever o mundo atual!"
echo "Arquivo: $BACKUP_FILE"
read -p "Continuar? (s/n) " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Cancelado."
    exit 1
fi

echo "🛑 Parando servidor..."
docker-compose stop minecraft-server

echo "🗑️ Removendo mundo atual..."
rm -rf "$WORLD_DIR"
mkdir -p "$WORLD_DIR"

echo "📦 Restaurando backup..."
tar -xzf "$BACKUP_FILE" -C "$WORLD_DIR"

echo "🚀 Iniciando servidor..."
docker-compose start minecraft-server

echo "✅ Backup restaurado com sucesso!"