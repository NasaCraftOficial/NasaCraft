# 🎮 Guia de Configuração - Servidor Minecraft NasaCraft

## 📋 Índice
1. [Pré-requisitos](#pré-requisitos)
2. [Instalação Rápida](#instalação-rápida)
3. [Configurações](#configurações)
4. [Gerenciamento](#gerenciamento)
5. [Troubleshooting](#troubleshooting)

---

## ✅ Pré-requisitos

### Sistema Operacional Compatível
- **Ubuntu 20.04+** (Recomendado)
- **CentOS 7+**
- **Windows 10+** (com WSL2)
- **macOS 10.14+**

### Requisitos Mínimos
- **CPU**: 2 cores
- **RAM**: 2GB (mínimo), 4GB+ (recomendado)
- **Armazenamento**: 20GB SSD
- **Internet**: 10+ Mbps upload

### Instalar Docker e Docker Compose

#### Ubuntu/Debian
```bash
# Atualizar sistema
sudo apt-get update
sudo apt-get upgrade -y

# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Adicionar usuário ao grupo docker
sudo usermod -aG docker $USER
newgrp docker

# Instalar Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verificar instalação
docker --version
docker-compose --version
```

#### CentOS/RHEL
```bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker

# Docker Compose (mesmo comando que Ubuntu)
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

#### Windows (WSL2)
```powershell
# Instalar WSL2
wsl --install

# Instalar Docker Desktop
# Baixar em: https://www.docker.com/products/docker-desktop

# Habilitar integração WSL2 em Docker Desktop settings
```

---

## 🚀 Instalação Rápida

### 1. Clone o Repositório
```bash
git clone https://github.com/NasaCraftOficial/NasaCraft.git
cd NasaCraft
```

### 2. Dar Permissões aos Scripts
```bash
chmod +x scripts/*.sh
```

### 3. Iniciar o Servidor
```bash
./scripts/start-server.sh
```

Pronto! O servidor está rodando em `localhost:25565`

---

## ⚙️ Configurações

### Editar `server.properties`

Os principais parâmetros:

```properties
# Porta (padrão: 25565)
server-port=25565

# Modo de jogo
# 0 = Survival (Padrão)
# 1 = Creative
# 2 = Adventure
# 3 = Spectator
gamemode=0

# Dificuldade
# 0 = Pacífica
# 1 = Fácil
# 2 = Normal (Padrão)
# 3 = Difícil
difficulty=2

# Máximo de jogadores
max-players=20

# PvP (true/false)
pvp=true

# Distância de renderização (5-32)
view-distance=10

# Whitelist (true = apenas lista branca pode entrar)
white-list=false
```

### Editar `docker-compose.yml`

Variáveis de ambiente principais:

```yaml
environment:
  EULA: "TRUE"                    # Concorda com EULA Minecraft
  MEMORY: 2G                      # Memória RAM
  MAX_PLAYERS: 20                 # Máximo de jogadores
  GAMEMODE: survival              # Modo de jogo
  DIFFICULTY: normal              # Dificuldade
  OPS: "Player1,Player2"          # Operadores (admins)
  ENABLE_WHITELIST: "false"       # Ativar whitelist
```

---

## 🎮 Gerenciamento

### Comandos Básicos

```bash
# Status do servidor
docker-compose ps

# Ver logs em tempo real
docker-compose logs -f minecraft-server

# Parar servidor gracefully
./scripts/stop-server.sh

# Parar imediatamente
docker-compose kill

# Reiniciar
docker-compose restart minecraft-server

# Remover containers e volumes
docker-compose down -v
```

### Executar Comandos no Servidor

```bash
# Usar RCON (Remote Console)
docker-compose exec minecraft-server rcon-cli

# Exemplos:
docker-compose exec minecraft-server rcon-cli "say Olá a todos!"
docker-compose exec minecraft-server rcon-cli "give Player1 diamond 64"
docker-compose exec minecraft-server rcon-cli "time set day"
docker-compose exec minecraft-server rcon-cli "weather clear"
```

### Backups

#### Backup Manual
```bash
./scripts/backup.sh
```

#### Restaurar Backup
```bash
./scripts/restore-backup.sh ./backups/nasacraft-20260901-120000.tar.gz
```

#### Backup Automático (Cron)
```bash
# Editar crontab
crontab -e

# Adicionar linha para backup a cada 6 horas
0 */6 * * * /home/usuario/NasaCraft/scripts/backup.sh >> /home/usuario/NasaCraft/logs/backup.log 2>&1
```

---

## 🔒 Segurança

### Whitelist de Jogadores

```bash
# Ativar whitelist
docker-compose exec minecraft-server rcon-cli "whitelist on"

# Adicionar jogador
docker-compose exec minecraft-server rcon-cli "whitelist add NomeDoJogador"

# Remover jogador
docker-compose exec minecraft-server rcon-cli "whitelist remove NomeDoJogador"

# Listar whitelist
docker-compose exec minecraft-server rcon-cli "whitelist list"
```

### Firewall

```bash
# UFW (Ubuntu)
sudo ufw allow 25565/tcp
sudo ufw allow 25575/tcp

# Firewalld (CentOS)
sudo firewall-cmd --permanent --add-port=25565/tcp
sudo firewall-cmd --permanent --add-port=25575/tcp
sudo firewall-cmd --reload
```

### RCON Password

⚠️ **IMPORTANTE**: Mude a senha RCON em `server.properties`:

```bash
# Gerar senha forte
openssl rand -base64 16

# Editar server.properties
rcon.password=SUA_SENHA_SEGURA
```

---

## 🐛 Troubleshooting

### "Connection refused"
```bash
# Verificar se container está rodando
docker-compose ps

# Ver logs de erro
docker-compose logs minecraft-server

# Reiniciar
docker-compose restart minecraft-server
```

### "Out of Memory"
```bash
# Aumentar memória em docker-compose.yml
environment:
  MEMORY: 4G  # ou mais

# Reiniciar
docker-compose down
docker-compose up -d
```

### "Can't connect to server"
```bash
# Verificar firewall
sudo ufw status

# Verificar se porta está aberta
netstat -tulpn | grep 25565

# Verificar IP público
curl https://api.ipify.org

# Conectar com IP: SEU_IP_PUBLICO:25565
```

### Mundo não salva
```bash
# Forçar save
docker-compose exec minecraft-server rcon-cli "save-all"

# Verificar permissões
ls -la world/

# Dar permissões
sudo chown -R $USER:$USER world/
```

---

## 📊 Monitoramento

### CPU e Memória
```bash
docker stats minecraft-server
```

### Estatísticas do Servidor
```bash
docker-compose exec minecraft-server rcon-cli "list"
docker-compose exec minecraft-server rcon-cli "say Teste"
```

---

## 🆘 Suporte

- **Docs Minecraft**: https://minecraft.fandom.com/wiki/Server
- **Docker Minecraft**: https://github.com/itzg/docker-minecraft-server
- **Issues**: https://github.com/NasaCraftOficial/NasaCraft/issues

---

## 📝 Notas Importantes

1. **Primeiro start**: Pode levar 2-3 minutos
2. **EULA**: Você concorda automaticamente ao usar
3. **Seed**: Deixe em branco para gerar aleatoriamente
4. **Online mode**: Com `true` requer autenticação Minecraft
5. **Backups**: São feitos a cada 6 horas automaticamente

---

**Boa sorte com seu servidor NasaCraft! 🎮✨**
