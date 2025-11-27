use('steam_games_db');

db.games.createIndex({ "price.final": 1 });

const explainSimpleIndex = db.games.find({ "price.final": 4999 }).explain("executionStats");
print("Execution time with simple index (ms):", explainSimpleIndex.executionStats.executionTimeMillis);
print("totalDocsExamined:", explainSimpleIndex.executionStats.totalDocsExamined);
print("totalKeysExamined:", explainSimpleIndex.executionStats.totalKeysExamined);