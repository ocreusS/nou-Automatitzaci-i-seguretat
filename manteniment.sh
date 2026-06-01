#!/bin/bash

LOG="manteniment.log"
: > "$LOG"

log() {
    echo "$1" | tee -a "$LOG"
}

run_sql() {
    log ""
    log "[SQL] $1"
    sudo -u postgres psql -d pagila -v ON_ERROR_STOP=1 -c "$1" 2>&1 | tee -a "$LOG"
    STATUS=${PIPESTATUS[0]}

    if [ "$STATUS" -ne 0 ]; then
        log "[ERROR] Ha fallat una comanda de manteniment."
        exit "$STATUS"
    fi
}

log "======================================"
log " Manteniment de la base de dades Pagila"
log "======================================"

run_sql "VACUUM ANALYZE rental;"
run_sql "VACUUM ANALYZE inventory;"
run_sql "VACUUM ANALYZE film;"
run_sql "VACUUM ANALYZE customer;"

run_sql "REINDEX TABLE rental;"
run_sql "REINDEX TABLE inventory;"
run_sql "REINDEX TABLE film;"
run_sql "REINDEX TABLE customer;"

log ""
log "[OK] Manteniment finalitzat correctament."
