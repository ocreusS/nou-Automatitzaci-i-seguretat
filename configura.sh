#!/bin/bash

LOG="configuracio-pagila.log"
: > "$LOG"

log() {
    echo "$1" | tee -a "$LOG"
}

run_cmd() {
    log ""
    log "[EXEC] $*"
    "$@" 2>&1 | tee -a "$LOG"
    STATUS=${PIPESTATUS[0]}

    if [ "$STATUS" -ne 0 ]; then
        log "[ERROR] Ha fallat la comanda anterior."
        exit "$STATUS"
    fi
}

log "======================================"
log " Configuració automàtica de Pagila"
log "======================================"

run_cmd chmod +x scripts-sql/00-prepara-pagila.sh
run_cmd bash scripts-sql/00-prepara-pagila.sh

for fitxer in scripts-sql/01-rols.sql scripts-sql/02-permisos.sql scripts-sql/03-vistes.sql scripts-sql/04-triggers.sql
do
    log ""
    log "[INFO] Executant $fitxer"
    run_cmd sudo -u postgres psql -d pagila -v ON_ERROR_STOP=1 -f "$fitxer"
done

log ""
log "[OK] Configuració finalitzada correctament."
