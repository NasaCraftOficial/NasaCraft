FROM openjdk:16-jdk-slim

# Instalações necessárias
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Criar usuário minecraft
RUN useradd -m -u 1000 minecraft

# Diretório de trabalho
WORKDIR /data

# Copiar servidor
COPY server.jar /data/
COPY server.properties /data/

# Dar permissões
RUN chown -R minecraft:minecraft /data

# Trocar para usuário minecraft
USER minecraft

# Expose porta
EXPOSE 25565 25575

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:25575/metrics || exit 1

# Comando de inicialização
CMD java -Xmx2G -Xms2G \
    -XX:+UseG1GC \
    -XX:MaxGCPauseMillis=50 \
    -XX:+ParallelRefProcEnabled \
    -XX:+AlwaysPreTouch \
    -XX:+DisableExplicitGC \
    -jar server.jar nogui