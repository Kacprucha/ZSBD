use('steam_games_db');

db.developers.createIndex({ name: 1 }, { unique: true });
db.publishers.createIndex({ name: 1 }, { unique: true });
db.genres.createIndex({ name: 1 }, { unique: true });
db.cacategories.createIndex({ name: 1 }, { unique: true });
