use('steam_games_db');

const updatedGameData = {
  name: "Updated Example RPG Game",
  required_age: 10
};

updateGame(3996191, updatedGameData);

db.games.find({ _id: 3996191 }, {_id: 1, name: 1, required_age: 1}).pretty();