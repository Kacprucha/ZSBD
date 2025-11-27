use('steam_games_db');

const explainNoIndex = db.games.find({ "price.final": 4999 }).explain("executionStats");
print("Execution time without index (ms):", explainNoIndex.executionStats.executionTimeMillis);
print("totalDocsExamined:", explainNoIndex.executionStats.totalDocsExamined);
print("totalKeysExamined:", explainNoIndex.executionStats.totalKeysExamined);