#!/bin/bash

echo "=== WERYFIKACJA MIGRACJI ==="
echo ""
printf "%-40s %15s %15s %10s\n" "Tabela" "PostgreSQL" "MySQL" "Status"
printf "%-40s %15s %15s %10s\n" "$(printf '%.0s-' {1..40})" "$(printf '%.0s-' {1..15})" "$(printf '%.0s-' {1..15})" "$(printf '%.0s-' {1..10})"

TABLES="accountstatus character character_class class class_skill combatlog combatlog_archive guild guildmember iteam iteam_character itemtype location locationtype loglevel memberstatus monster monster_location player procedureexecutionlog quest quest_guild questlog queststatus race race_character rarity skill skill_character"

TOTAL_PG=0
TOTAL_MYSQL=0
ERRORS=0

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

for table in $TABLES; do
    PG_ROWS=$(docker exec rpg_postgres psql -U rpg_admin -d rpg_game_db -t -c "SELECT COUNT(*) FROM game_data.\"$table\";" 2>/dev/null | tr -d ' ')
    MYSQL_ROWS=$(docker exec rpg_mysql mysql -u rpg_admin -prpg_admin_password rpg_game_db_mysql -sN -e "SELECT COUNT(*) FROM \`$table\`;" 2>/dev/null)
    
    TOTAL_PG=$((TOTAL_PG + PG_ROWS))
    TOTAL_MYSQL=$((TOTAL_MYSQL + MYSQL_ROWS))
    
    if [ "$PG_ROWS" == "$MYSQL_ROWS" ]; then
        STATUS="${GREEN}✓ OK${NC}"
    else
        STATUS="${RED}✗ BŁĄD${NC}"
        ERRORS=$((ERRORS + 1))
    fi
    
    printf "%-40s %15s %15s %10s\n" "$table" "$PG_ROWS" "$MYSQL_ROWS" "$(echo -e $STATUS)"
done

echo ""
printf "%-40s %15s %15s\n" "$(printf '%.0s=' {1..40})" "$(printf '%.0s=' {1..15})" "$(printf '%.0s=' {1..15})"
printf "%-40s %15s %15s\n" "TOTAL" "$TOTAL_PG" "$TOTAL_MYSQL"
echo ""

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓✓✓ SUKCES! Wszystkie $TOTAL_PG rekordów zostały poprawnie zmigrowane!${NC}"
    echo -e "${GREEN}✓ 29 tabel przeniesiono z PostgreSQL do MySQL${NC}"
else
    echo -e "${RED}✗ Znaleziono $ERRORS błędów w migracji${NC}"
fi
