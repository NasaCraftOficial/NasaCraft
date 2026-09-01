# 🎮 Guia de Host Minecraft - NasaCraft

## Opções de Host Recomendadas

### 1. **Hosting Especializado (Recomendado para iniciantes)**
- **Nitrado**: https://nitrado.net
- **G-Portal**: https://www.g-portal.com
- **Aternos**: https://aternos.org (Grátis com limitações)
- **Apex Hosting**: https://apexhosting.com

**Vantagens:**
- ✅ Fácil de configurar
- ✅ Suporte técnico incluído
- ✅ Backups automáticos
- ✅ DDoS protection

---

### 2. **Cloud VPS (Controle total)**

#### DigitalOcean
```bash
# Criar droplet com 2GB RAM mínimo
# Ubuntu 20.04 LTS
# $5-12/mês
```

#### AWS / Google Cloud / Azure
- Mais caro mas escalável
- EC2 (AWS) ou Compute Engine (Google)

---

### 3. **Seu Computador (Local)**
```bash
# Requer:
- Computador 24/7 ligado
- Internet estável (mínimo 10 Mbps upload)
- Firewall configurado
- Port forwarding (porta 25565)
```

---

## Configuração Rápida - DigitalOcean

### Passo 1: Criar Droplet
1. Ir em `Droplets` → `Create Droplet`
2. Escolher:
   - **OS**: Ubuntu 20.04 LTS
   - **Plan**: $5/mês (2GB RAM, 50GB SSD)
   - **Region**: Mais próxima dos jogadores
3. SSH Key ou Senha

### Passo 2: Conectar via SSH
```bash
ssh root@seu_ip_aqui
```

### Passo 3: Instalar Java
```bash
apt update
apt install openjdk-16-jre-headless -y
java -version
```

### Passo 4: Baixar Minecraft Server
```bash
cd /home/minecraft
wget https://launcher.mojang.com/v1/objects/[hash]/server.jar
```

### Passo 5: Iniciar Servidor
```bash
java -Xmx1024M -Xms1024M -jar server.jar nogui
```

### Passo 6: Configurar Firewall
```bash
ufw allow 22/tcp    # SSH
ufw allow 25565/tcp # Minecraft
ufw enable
```

---

## Arquivo `server.properties`

```properties
# Configurações básicas
server-port=25565
max-players=20
level-name=world
motd=NasaCraft Server
difficulty=2
gamemode=0
pvp=true
enable-command-blocks=true

# Performance
view-distance=10
max-tick-time=60000
spawn-protection=16
```

---

## Docker (Recomendado)

```dockerfile
FROM openjdk:16-jdk-slim

WORKDIR /minecraft
COPY server.jar .
COPY server.properties .

EXPOSE 25565

CMD ["java", "-Xmx1024M", "-Xms1024M", "-jar", "server.jar", "nogui"]
```

```bash
docker build -t nasacraft-server .
docker run -d -p 25565:25565 --name minecraft nasacraft-server
```

---

## Monitoramento & Backups

### Script de Backup
```bash
#!/bin/bash
BACKUP_DIR="/backups/minecraft"
mkdir -p $BACKUP_DIR
tar -czf $BACKUP_DIR/world-$(date +%Y%m%d-%H%M%S).tar.gz /home/minecraft/world
find $BACKUP_DIR -mtime +7 -delete  # Manter últimos 7 dias
```

### Agendar com Cron
```bash
0 */6 * * * /path/to/backup.sh  # Backup a cada 6 horas
```

---

## Custo Estimado (Mensal)

| Opção | Preço | Players |
|-------|-------|---------|
| Aternos (Grátis) | R$ 0 | 20 |
| Nitrado | R$ 30-80 | 10-50 |
| DigitalOcean | R$ 25-50 | 20-50 |
| AWS | R$ 50-200+ | 50+ |

---

## Links Úteis

- [Documentação Oficial Minecraft](https://minecraft.fandom.com/wiki/Server)
- [Spigot Server](https://www.spigotmc.org/)
- [Paper Server](https://papermc.io/)
- [Docker Hub Minecraft](https://hub.docker.com/r/itzg/minecraft-server)

---

## Próximas Ações

1. Escolher plataforma de host
2. Criar conta e configurar servidor
3. Ajustar `server.properties`
4. Configurar backups
5. Compartilhar IP com jogadores

Qual opção você prefere? 🚀
