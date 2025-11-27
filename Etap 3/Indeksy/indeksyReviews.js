use('steam_games_db');

db.reviews.createIndex({ appid: 1 });

db.reviews.createIndex({ is_positive: 1 });

db.reviews.createIndex({ language: 1 });

db.reviews.createIndex({ "author.steamid": 1 });

db.reviews.createIndex({ "timestamps.created": -1 });

db.reviews.createIndex({ "votes.weighted_score": -1 });

db.reviews.createIndex({ appid: 1, is_positive: 1 });

db.reviews.createIndex({ 
  "author.playtime_at_review": 1, 
  is_positive: 1 
});

db.reviews.createIndex({ hidden: 1, flagged: 1 });