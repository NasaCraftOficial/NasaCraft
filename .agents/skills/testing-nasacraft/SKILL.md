# Testing NasaCraft Game

## Overview
NasaCraft is a browser-based Minecraft-style voxel game built as a single `index.html` file using Three.js (loaded from CDN). It requires no build step and can be served as a static file.

## Deployment
- The game is a single static HTML file - deploy using `deploy frontend` with the repo root as the directory
- No build step required, no dependencies to install
- Three.js is loaded from cdnjs.cloudflare.com CDN, so internet access is required

## Testing Approach

### Menu Screen
1. Open the deployed URL in a browser
2. Verify: "NASACRAFT" title with glowing blue animation, "EXPLORE O UNIVERSO" subtitle, "INICIAR JOGO" button, controls info text, twinkling star background

### Starting the Game
1. Click "INICIAR JOGO" button
2. Verify: Pointer lock engages (browser shows ESC prompt), 3D voxel terrain renders, crosshair appears center screen, HUD hotbar with 9 slots at bottom, info panel top-left (coordinates, biome, chunk count)

### Movement
- WASD keys move the player; verify coordinates change in the info panel
- Mouse movement controls camera look (requires pointer lock to be active)
- Space bar jumps (only when on ground)

### Block Interaction
- **Destruction (left click)**: Look at a block (white wireframe highlight appears), left click to destroy. Particle effects should appear.
- **Placement (right click)**: Right click on a surface to place the currently selected block adjacent to the targeted block.
- **Block selection**: Press 1-9 to switch hotbar slot, or use scroll wheel. Block name updates below hotbar.

### Pause
- Press ESC to return to menu screen
- Click "INICIAR JOGO" to resume gameplay

## Known Considerations
- Pointer lock is required for mouse look - clicking the game canvas engages it
- The game is desktop-only; no touch/mobile controls
- All UI text is in Portuguese (pt-BR)
- Terrain uses sine-wave composition (not Perlin noise), so landscapes may appear periodic at very large scales
- Block interaction requires being within 8 blocks of the target
- Bedrock (y=0) cannot be broken
- Testing block interaction via automated tools (computer use) can be tricky due to pointer lock - you may need to click the canvas first to re-engage pointer lock after any ESC press

## Devin Secrets Needed
None - this is a static HTML game with no authentication or API keys required.
