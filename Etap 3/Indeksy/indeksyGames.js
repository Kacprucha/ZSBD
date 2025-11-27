use('steam_games_db');

db.games.createIndex({ "price.final": 1 });

db.games.createIndex({ developer_ids: 1 });

db.games.createIndex({ genre_ids: 1 });

db.games.createIndex({ "reception.metacritic_score": -1 });

db.games.createIndex({ deleted: 1 });

db.games.createIndex({ release_date: -1 });

db.games.createIndex({ name: "text", description: "text" });

db.games.createIndex({ type: 1, "price.final": 1 });

db.games.createIndex({ 
  "platforms.windows": 1, 
  "platforms.mac": 1, 
  "platforms.linux": 1 
});

db.games.createIndex({ genre_ids: 1, "price.final": 1 });
