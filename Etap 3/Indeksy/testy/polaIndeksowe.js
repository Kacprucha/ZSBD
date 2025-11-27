use('steam_games_db');

db.games.createIndex({ "price.final": 1, name: 1 });

const explainCovered = db.games.find(
  { "price.final": 4999 },
  { _id: 0, "price.final": 1, name: 1 }
).explain("executionStats");
print("Execution time with covered index (ms):", explainCovered.executionStats.executionTimeMillis);
print("totalDocsExamined:", explainCovered.executionStats.totalDocsExamined);
print("totalKeysExamined:", explainCovered.executionStats.totalKeysExamined);