# 🎮 NasaCraft - Servidor Minecraft

Solução completa e containerizada para hospedar um servidor Minecraft com Docker Compose.

## ⚡ Quick Start

```bash
# 1. Clonar repositório
git clone https://github.com/NasaCraftOficial/NasaCraft.git
cd NasaCraft

# 2. Iniciar servidor
chmod +x scripts/*.sh
./scripts/start-server.sh

# 3. Conectar ao servidor
# IP: localhost:25565 (local)
# IP: SEU_IP_PUBLICO:25565 (remoto)
```

## 📦 O que está incluído

- ✅ **Docker Compose** - Configuração pronta
- ✅ **Gerenciador de Backups** - Automático a cada 6 horas
- ✅ **Scripts de Gerenciamento** - Start, stop, backup, restore
- ✅ **Documentação Completa** - Setup guide + troubleshooting
- ✅ **RCON Console** - Executar comandos no servidor
- ✅ **Health Checks** - Monitoramento automático

## 📂 Estrutura de Arquivos

```
NasaCraft/
├── docker-compose.yml       # Configuração Docker
├── Dockerfile              # Imagem customizada (opcional)
├── server.properties       # Configurações do servidor
├── scripts/
│   ├── start-server.sh    # Iniciar servidor
│   ├── stop-server.sh     # Parar servidor
│   ├── backup.sh          # Fazer backup
│   └── restore-backup.sh  # Restaurar backup
├── docs/
│   └── SETUP_GUIDE.md     # Guia completo de instalação
├── world/                 # Dados do mundo (gitignored)
├── backups/              # Backups automáticos (gitignored)
└── logs/                 # Logs do servidor (gitignored)
```

## 🚀 Comandos Essenciais

### Inicializar
```bash
./scripts/start-server.sh
```

### Parar Gracefully
```bash
./scripts/stop-server.sh
```

### Ver Logs
```bash
docker-compose logs -f minecraft-server
```

### Backup Manual
```bash
./scripts/backup.sh
```

### Restaurar Backup
```bash
./scripts/restore-backup.sh ./backups/nasacraft-TIMESTAMP.tar.gz
```

### Executar Comando no Servidor
```bash
docker-compose exec minecraft-server rcon-cli "say Olá!"
docker-compose exec minecraft-server rcon-cli "give Player1 diamond 64"
docker-compose exec minecraft-server rcon-cli "time set day"
```

## ⚙️ Configurações Principais

### Editar `docker-compose.yml`
```yaml
environment:
  MAX_PLAYERS: 20          # Aumentar jogadores
  MEMORY: 2G              # Aumentar RAM
  DIFFICULTY: normal      # normal, hard, easy, peaceful
  GAMEMODE: survival      # survival, creative, adventure
  ENABLE_WHITELIST: false # true = só lista branca
```

### Editar `server.properties`
```properties
server-port=25565        # Porta do servidor
level-name=NasaCraft     # Nome do mundo
max-players=20           # Máximo de jogadores
difficulty=2             # Dificuldade (0-3)
pvp=true                 # PvP ligado/desligado
view-distance=10         # Distância de renderização
```

## 🔒 Segurança

### Ativar Whitelist
```bash
# Editar docker-compose.yml
ENABLE_WHITELIST: "true"

# Adicionar jogadores
docker-compose exec minecraft-server rcon-cli "whitelist add Player1"
docker-compose exec minecraft-server rcon-cli "whitelist add Player2"
```

### Firewall (Ubuntu)
```bash
sudo ufw allow 25565/tcp
sudo ufw allow 25575/tcp
```

## 📊 Requisitos Mínimos

| Aspecto | Recomendação |
|---------|-------------|
| **CPU** | 2+ cores |
| **RAM** | 2GB min, 4GB+ ideal |
| **SSD** | 20GB+ |
| **Banda** | 10+ Mbps upload |
| **Players** | 5-20 simultâneos |

## 🐛 Troubleshooting

### Servidor não inicia
```bash
docker-compose logs minecraft-server
# Verificar espaço em disco e RAM disponível
```

### Connection refused
```bash
docker-compose ps
# Verificar se container está Up
firewall-cmd --list-all
# Verificar firewall
```

### Mundo não salva
```bash
docker-compose exec minecraft-server rcon-cli "save-all"
ls -la world/
sudo chown -R $USER:$USER world/
```

## 📚 Documentação Completa

Para um guia detalhado de instalação, configuração e troubleshooting, consulte:
👉 **[SETUP_GUIDE.md](docs/SETUP_GUIDE.md)**

## 🔗 Links Úteis

- 📖 [Documentação Minecraft](https://minecraft.fandom.com/wiki/Server)
- 🐳 [Docker Minecraft Image](https://github.com/itzg/docker-minecraft-server)
- 📝 [Commands Reference](https://minecraft.fandom.com/wiki/Commands)
- 🛡️ [Security Best Practices](https://minecraft.fandom.com/wiki/Server/Getting_started_with_servers)

## 💬 Suporte

Encontrou um problema? 
- 🐛 Abra uma [issue](https://github.com/NasaCraftOficial/NasaCraft/issues)
- 💬 Veja [troubleshooting](docs/SETUP_GUIDE.md#-troubleshooting)

## 📝 Licença

Este projeto está sob licença MIT.

---

**Comece seu servidor NasaCraft agora! 🚀🎮**

```bash
./scripts/start-server.sh
```