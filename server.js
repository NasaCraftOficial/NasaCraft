// Minecraft Server Host - NasaCraft
// Servidor básico de Minecraft usando Node.js com protocolo Minecraft Java Edition

const dgram = require('dgram');
const net = require('net');
const fs = require('fs');

const SERVER_PORT = 25565;
const SERVER_HOST = 'localhost';
const MOTD = '§6NasaCraft §7- Welcome to the Server!';
const MAX_PLAYERS = 20;
const ONLINE_PLAYERS = 0;

// Configurações do servidor
const serverConfig = {
  port: SERVER_PORT,
  host: SERVER_HOST,
  motd: MOTD,
  maxPlayers: MAX_PLAYERS,
  onlinePlayers: ONLINE_PLAYERS,
  version: '1.20.1'
};

// Salvar configurações em arquivo JSON
function saveConfig() {
  fs.writeFileSync('server.json', JSON.stringify(serverConfig, null, 2));
  console.log('Configurações salvas em server.json');
}

// Carregar configurações
function loadConfig() {
  if (fs.existsSync('server.json')) {
    const data = fs.readFileSync('server.json');
    Object.assign(serverConfig, JSON.parse(data));
    console.log('Configurações carregadas');
  }
}

// Servidor TCP para conexões Minecraft
const server = net.createServer((socket) => {
  console.log(`[${new Date().toLocaleTimeString()}] Conexão recebida de: ${socket.remoteAddress}`);
  
  socket.on('data', (data) => {
    console.log(`Dados recebidos (${data.length} bytes)`);
    handleMinecraftPacket(socket, data);
  });

  socket.on('end', () => {
    console.log(`[${new Date().toLocaleTimeString()}] Cliente desconectado: ${socket.remoteAddress}`);
  });

  socket.on('error', (err) => {
    console.error(`[${new Date().toLocaleTimeString()}] Erro de conexão:`, err.message);
  });
});

// Processar pacotes do Minecraft
function handleMinecraftPacket(socket, data) {
  try {
    // Handshake packet
    if (data[0] === 0x00) {
      console.log('Handshake recebido');
      // Enviar Status Response
      sendStatusResponse(socket);
    }
    
    // Status Request packet
    if (data[0] === 0x00 && data.length > 5) {
      console.log('Status request recebido');
      sendPingResponse(socket);
    }
  } catch (err) {
    console.error('Erro ao processar pacote:', err.message);
  }
}

// Enviar resposta de status
function sendStatusResponse(socket) {
  const response = {
    version: {
      name: serverConfig.version,
      protocol: 765
    },
    players: {
      max: serverConfig.maxPlayers,
      online: serverConfig.onlinePlayers,
      sample: []
    },
    description: {
      text: serverConfig.motd
    }
  };

  const json = JSON.stringify(response);
  const packet = Buffer.alloc(json.length + 10);
  
  let offset = 0;
  packet[offset++] = 0x00; // Packet ID
  
  // VarInt encoding do tamanho
  let size = json.length;
  while ((size & 0xFFFFFF80) !== 0) {
    packet[offset++] = (size & 0x7F) | 0x80;
    size >>>= 7;
  }
  packet[offset++] = size & 0x7F;
  
  packet.write(json, offset);
  
  socket.write(packet.slice(0, offset + json.length));
}

// Enviar resposta de ping
function sendPingResponse(socket) {
  const packet = Buffer.alloc(9);
  packet[0] = 0x01; // Packet ID (Pong)
  packet.writeBigInt64BE(BigInt(Date.now()), 1);
  socket.write(packet);
}

// Iniciar servidor
function startServer() {
  loadConfig();
  
  server.listen(serverConfig.port, serverConfig.host, () => {
    console.log('='.repeat(50));
    console.log('🚀 NASACRAFT SERVER INICIADO');
    console.log('='.repeat(50));
    console.log(`📍 Endereço: ${serverConfig.host}:${serverConfig.port}`);
    console.log(`🎮 Versão: ${serverConfig.version}`);
    console.log(`👥 Slots: ${serverConfig.onlinePlayers}/${serverConfig.maxPlayers}`);
    console.log(`📝 MOTD: ${serverConfig.motd}`);
    console.log('='.repeat(50));
    console.log('Aguardando conexões...\n');
  });

  server.on('error', (err) => {
    console.error('Erro no servidor:', err.message);
    if (err.code === 'EADDRINUSE') {
      console.error(`Porta ${serverConfig.port} já está em uso!`);
    }
  });
}

// Graceful shutdown
process.on('SIGINT', () => {
  console.log('\n[SHUTDOWN] Encerrando servidor...');
  saveConfig();
  server.close(() => {
    console.log('[SHUTDOWN] Servidor encerrado com sucesso');
    process.exit(0);
  });
});

// Iniciar
startServer();