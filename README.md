# Bürokratie-Imperium

Ein Idle-Spiel über deutsche Amtsstuben: Akten stempeln, Stellen schaffen, Ämter ausbauen und vom Dorf bis nach Brüssel umziehen.

**Spielen:** https://manu-tri.github.io/buerokratie-imperium/

Auf dem Handy den Link öffnen und „Zum Home-Bildschirm“ wählen. Dann läuft das Spiel wie eine App, auch offline.

## Aufbau

- `index.html` – das komplette Spiel
- `three.min.js` – Three.js r128 für die 3D-Stadtansicht (lokal, damit das Spiel offline läuft)
- `manifest.webmanifest`, `sw.js`, `icons/` – installierbare Web-App mit Offline-Betrieb
- `ios/` – Xcode-Projekt für die native iPhone-App (`ios/sync-web.sh` übernimmt die aktuelle `index.html`)
