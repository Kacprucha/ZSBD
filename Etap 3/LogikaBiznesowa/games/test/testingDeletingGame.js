use('steam_games_db');

softDeleteGame(3996191);

console.log("Game soft deleted.");
const softDeletedGame = db.games.findOne({ _id: 3996191 }, { deleted: 1, deleted_at: 1 });
console.log(softDeletedGame);

restoreGame(3996191);

console.log("Game restored.");
const restoredGame = db.games.findOne({ _id: 3996191 }, { deleted: 1, deleted_at: 1 });
console.log(restoredGame);

permanentlyDeleteGame(3996191);

console.log("Game permanently deleted.");
const deletedGame = db.games.findOne({ _id: 3996191 });
console.log(deletedGame);