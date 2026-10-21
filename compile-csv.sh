#!/usr/bin/env bash
# Genera los CSV de ebusd a partir de los .tsp de src/.
# Comprueba node >= 22, npm y python3 antes de compilar.
set -euo pipefail

cd "$(dirname "$0")"
# maintsp ordena los imports con sort. Con el locale del sistema el punto
# se ignora y src/main.tsp cambia de orden en cada ejecución.
export LC_ALL=C

NODE_MIN=22

help() {
  cat <<EOF

Hace falta esto para generar los CSV:

  * Node.js ${NODE_MIN} o superior (incluye el compilador de TypeSpec).
    En Debian 13, "sudo apt install npm" instala Node 20 y no sirve:
    el compilador usa fs.promises.glob, que existe desde Node 22.
    Para instalar Node.js 24 LTS, que ya incluye npm:

      curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash -
      sudo apt-get install -y nodejs

    Comprueba con: node -v

  * npm, el que viene con esa instalación de Node.js.
    Comprueba con: npm -v

  * python3, solo la biblioteca estándar (no hace falta pip).
    En Debian: sudo apt install python3
    Comprueba con: python3 --version

Cuando los tres respondan, vuelve a ejecutar:

  ./compile-csv.sh

EOF
}

missing=0

if ! command -v node >/dev/null 2>&1; then
  echo "No está el comando node."
  missing=1
else
  node_major="$(node -p "process.versions.node.split('.')[0]")"
  if [ "$node_major" -lt "$NODE_MIN" ]; then
    echo "Node.js $(node -v) es anterior a la versión ${NODE_MIN}."
    missing=1
  fi
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "No está el comando npm."
  missing=1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "No está el comando python3."
  missing=1
fi

if [ "$missing" -ne 0 ]; then
  help
  exit 1
fi

if [ ! -f package.json ]; then
  echo "Ejecuta este script desde el repositorio ebusd-configuration."
  exit 1
fi

if [ ! -d node_modules/@typespec/compiler ] || [ ! -d node_modules/@ebusd/ebus-typespec ]; then
  echo "Instalando dependencias del proyecto (npm install)..."
  npm install
fi

npm run maintsp
npm run compile-en

echo "CSV generados en outcsv/@ebusd/ebus-typespec/"
