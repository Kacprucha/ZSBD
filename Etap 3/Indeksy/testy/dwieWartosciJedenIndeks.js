use('steam_games_db');

db.reviews.createIndex({ appid: 1 });
// No idex on is_positive

const exp1 = db.reviews.find({ appid: 427520, is_positive: true }).explain("executionStats");
print("Execution time with index (ms):", exp1.executionStats.executionTimeMillis);
print("totalDocsExamined:", exp1.executionStats.totalDocsExamined);
print("totalKeysExamined:", exp1.executionStats.totalKeysExamined);