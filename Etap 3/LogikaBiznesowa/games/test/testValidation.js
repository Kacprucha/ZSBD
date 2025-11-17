use('steam_games_db');

const invalidGameData = {
  _id: getNextSequence("game_id"),
  name: "Invalid Price Game",
  type: "game",
  required_age: 30
}

try {
const result = db.games.insertOne(invalidGameData);
}
catch (e) {
  console.log("Error inserting game:", e.message);
}