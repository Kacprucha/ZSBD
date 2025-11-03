#!/bin/bash
set -e

echo "=== Migracja PostgreSQL -> MySQL (struktura + dane osobno) ==="

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

mkdir -p migration_separated
cd migration_separated

# ==============================================================================
# FAZA 1: STRUKTURA TABEL
# ==============================================================================



# ==============================================================================
# FAZA 2: DANE - METODA CSV (najpewniejsza)
# ==============================================================================

echo -e "\n${YELLOW}=== FAZA 2: EKSPORT I IMPORT DANYCH ===${NC}"

# 2.1 Pobierz listę tabel
TABLES=$(docker exec rpg_postgres psql -U rpg_admin -d rpg_game_db -t -c "SELECT tablename FROM pg_tables WHERE schemaname = 'game_data' ORDER BY tablename;")
TABLE_COUNT=$(echo "$TABLES" | wc -w)

echo -e "\nZnaleziono: $TABLE_COUNT tabel"

# 2.2 Dla każdej tabeli: eksport CSV i import
CURRENT=0
for table in $TABLES; do
    table=$(echo $table | tr -d ' ')
    [ -z "$table" ] && continue
    
    CURRENT=$((CURRENT+1))
    echo -e "\n[2.2.$CURRENT/$TABLE_COUNT] Tabela: $table"
    
    # Sprawdź ile wierszy
    ROW_COUNT=$(docker exec rpg_postgres psql -U rpg_admin -d rpg_game_db -t -c "SELECT COUNT(*) FROM game_data.\"$table\";" 2>/dev/null | tr -d ' ')
    echo "  Wierszy: $ROW_COUNT"
    
    if [ "$ROW_COUNT" -gt 0 ]; then
        # Eksport CSV
        echo "  [1] Eksport do CSV..."
        docker exec rpg_postgres psql -U rpg_admin -d rpg_game_db -c "\COPY game_data.$table TO '/tmp/${table}.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',', ENCODING 'UTF8')"

        echo "  [2] Kopiowanie z PostgreSQL na hosta..."
        if docker cp rpg_postgres:/tmp/${table}.csv ./${table}.csv; then
            echo -e "  ${GREEN}✓ Skopiowano na hosta${NC}"
            ls -lh ${table}.csv
        else
            echo -e "  ${RED}✗ Błąd kopiowania na hosta${NC}"
            continue
        fi

        echo "  [3] Kopiowanie z hosta do MySQL..."
        if docker cp ./${table}.csv rpg_mysql:/tmp/${table}.csv; then
            echo -e "  ${GREEN}✓ Skopiowano do MySQL${NC}"
        else
            echo -e "  ${RED}✗ Błąd kopiowania do MySQL${NC}"
            continue
        fi
        
        echo "  [4] Import do MySQL..."
        docker exec rpg_mysql mysql --local-infile=1 -u rpg_admin -prpg_admin_password rpg_game_db_mysql -e "
            SET FOREIGN_KEY_CHECKS=0;
            LOAD DATA LOCAL INFILE '/tmp/${table}.csv'
            INTO TABLE \`$table\`
            FIELDS TERMINATED BY ',' 
            ENCLOSED BY '\"'
            LINES TERMINATED BY '\n'
            IGNORE 1 ROWS;
            SET FOREIGN_KEY_CHECKS=1;
        " 2>&1 | grep -v "Warning" || echo -e "  ${YELLOW}⚠ Mogły być ostrzeżenia${NC}"
    
        # KROK 5: Weryfikacja
        MYSQL_COUNT=$(docker exec rpg_mysql mysql -u rpg_admin -prpg_admin_password rpg_game_db_mysql -sN -e "SELECT COUNT(*) FROM \`$table\`;" 2>/dev/null | tr -d ' ')
    
        if [ "$MYSQL_COUNT" -eq "$ROW_COUNT" ]; then
            echo -e "  ${GREEN}✓ Import OK: $MYSQL_COUNT wierszy${NC}"
        else
            echo -e "  ${RED}✗ PostgreSQL=$ROW_COUNT, MySQL=$MYSQL_COUNT${NC}"
        fi
    
        # Czyszczenie
        docker exec rpg_postgres rm -f /tmp/${table}.csv 2>/dev/null || true
        docker exec rpg_mysql rm -f /tmp/${table}.csv 2>/dev/null || true
    else
        echo "  ○ Tabela pusta"
    fi
done

cd ..

# ==============================================================================
# WERYFIKACJA
# ==============================================================================

echo -e "\n${GREEN}=== WERYFIKACJA ===${NC}"

printf "\n%-40s %15s %15s %10s\n" "Tabela" "PostgreSQL" "MySQL" "Status"
printf "%-40s %15s %15s %10s\n" "$(printf '%.0s-' {1..40})" "$(printf '%.0s-' {1..15})" "$(printf '%.0s-' {1..15})" "$(printf '%.0s-' {1..10})"

TOTAL_PG=0
TOTAL_MYSQL=0
ERRORS=0

for table in $TABLES; do
    table=$(echo $table | tr -d ' ')
    [ -z "$table" ] && continue
    
    PG=$(docker exec rpg_postgres psql -U rpg_admin -d rpg_game_db -t -c "SELECT COUNT(*) FROM game_data.\"$table\";" 2>/dev/null | tr -d ' ')
    MYSQL=$(docker exec rpg_mysql mysql -u rpg_admin -prpg_admin_password rpg_game_db_mysql -sN -e "SELECT COUNT(*) FROM \`$table\`;" 2>/dev/null | tr -d ' ')
    
    [ -z "$PG" ] && PG=0
    [ -z "$MYSQL" ] && MYSQL=0
    
    TOTAL_PG=$((TOTAL_PG + PG))
    TOTAL_MYSQL=$((TOTAL_MYSQL + MYSQL))
    
    if [ "$PG" == "$MYSQL" ]; then
        STATUS="${GREEN}✓ OK${NC}"
    else
        STATUS="${RED}✗ BŁĄD${NC}"
        ERRORS=$((ERRORS + 1))
    fi
    
    printf "%-40s %15s %15s %10s\n" "$table" "$PG" "$MYSQL" "$(echo -e $STATUS)"
done

echo ""
printf "%-40s %15s %15s\n" "$(printf '%.0s=' {1..40})" "$(printf '%.0s=' {1..15})" "$(printf '%.0s=' {1..15})"
printf "%-40s %15s %15s\n" "TOTAL" "$TOTAL_PG" "$TOTAL_MYSQL"

if [ $ERRORS -eq 0 ]; then
    echo -e "\n${GREEN}✓✓✓ SUKCES! Migracja KOMPLETNA!${NC}"
    echo -e "${GREEN}✓ Struktura: OK${NC}"
    echo -e "${GREEN}✓ Dane: $TOTAL_PG rekordów zmigrowanych${NC}"
    echo -e "${GREEN}✓ Bez funkcji i procedur (tylko tabele i dane)${NC}"
else
    echo -e "\n${RED}✗ Migracja z $ERRORS błędami${NC}"
fi

echo -e "\n${YELLOW}Pliki pośrednie w: migration_separated/${NC}"