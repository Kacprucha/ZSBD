use('steam_games_db');

db.reviews.createIndex({ appid: 1, is_positive: 1 });

const exp2 = db.reviews.find({ appid: 427520, is_positive: true }).explain("executionStats");
print("Execution time with compound index (ms):", exp2.executionStats.executionTimeMillis);
print("totalDocsExamined:", exp2.executionStats.totalDocsExamined);
print("totalKeysExamined:", exp2.executionStats.totalKeysExamined);