#!/bin/bash

# Script de parada do servidor NasaCraft
# Uso: ./scripts/stop-server.sh

echo "🛑 Parando servidor NasaCraft Minecraft..."

# Avisar jogadores
docker-compose exec -T minecraft-server rcon-cli say "Servidor vai desligar em 60 segundos! Salve seu progresso!"
sleep 30

docker-compose exec -T minecraft-server rcon-cli say "Servidor vai desligar em 30 segundos!"
sleep 20

docker-compose exec -T minecraft-server rcon-cli say "Servidor desligando em 10 segundos!"
sleep 10

# Fazer save-all
echo "💾 Salvando mundo..."
docker-compose exec -T minecraft-server rcon-cli save-all

# Parar servidor gracefully
echo "⏹️ Parando containers..."
docker-compose stop

echo "✅ Servidor parado com sucesso!"