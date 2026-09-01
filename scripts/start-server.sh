#!/bin/bash

# Script de inicialização do servidor NasaCraft Minecraft
# Uso: ./scripts/start-server.sh

set -e

echo "🎮 Iniciando Servidor NasaCraft Minecraft..."
echo "=================================="

# Verificar se Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "❌ Docker não está instalado. Instale em: https://docs.docker.com/get-docker/"
    exit 1
fi

# Verificar se docker-compose está instalado
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose não está instalado. Instale em: https://docs.docker.com/compose/install/"
    exit 1
fi

# Criar diretórios necessários
mkdir -p world logs backups

# Dar permissões
chmod -R 755 world logs backups

# Iniciar containers
echo "📦 Iniciando containers Docker..."
docker-compose up -d

# Aguardar inicialização
echo "⏳ Aguardando inicialização do servidor (30 segundos)..."
sleep 30

# Verificar status
if docker-compose ps | grep -q "Up"; then
    echo "✅ Servidor iniciado com sucesso!"
    echo ""
    echo "📊 Status dos containers:"
    docker-compose ps
    echo ""
    echo "🔗 Conecte-se ao servidor:"
    echo "   IP: localhost:25565"
    echo "   Ou use seu IP público:"
    
    # Tentar obter IP público
    if command -v curl &> /dev/null; then
        PUBLIC_IP=$(curl -s https://api.ipify.org)
        echo "   IP Público: $PUBLIC_IP:25565"
    fi
    
    echo ""
    echo "📝 Logs:"
    docker-compose logs -f minecraft-server
else
    echo "❌ Erro ao iniciar servidor"
    docker-compose logs minecraft-server
    exit 1
fi