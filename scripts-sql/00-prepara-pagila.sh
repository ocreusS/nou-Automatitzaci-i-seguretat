#!/bin/bash
set -e

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$BASE_DIR"

echo "[INFO] Preparant base de dades Pagila..."

if [ -d "pagila" ]; then
    echo "[INFO] Esborro la carpeta pagila anterior per començar net."
    rm -rf pagila
fi

git clone https://github.com/devrimgunduz/pagila.git

echo "[INFO] Esborro la base de dades pagila si ja existia."
sudo -u postgres dropdb --if-exists pagila

echo "[INFO] Creo la base de dades pagila."
sudo -u postgres createdb pagila

echo "[INFO] Carrego l'esquema de Pagila."
sudo -u postgres psql -d pagila -v ON_ERROR_STOP=1 -f pagila/pagila-schema.sql

echo "[INFO] Carrego les dades de Pagila."
sudo -u postgres psql -d pagila -v ON_ERROR_STOP=1 -f pagila/pagila-insert-data.sql

echo "[OK] Pagila s'ha carregat correctament."
