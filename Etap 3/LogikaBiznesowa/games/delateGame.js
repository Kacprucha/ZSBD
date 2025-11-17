function softDeleteGame(gameId) {
  return db.games.updateOne(
    { _id: gameId },
    { 
      $set: { 
        deleted: true,
        deleted_at: new Date()
      }
    }
  );
}

function restoreGame(gameId) {
  return db.games.updateOne(
    { _id: gameId },
    { 
      $set: { deleted: false },
      $unset: { deleted_at: "" }
    }
  );
}

function permanentlyDeleteGame(gameId) {
  return db.games.deleteOne({ _id: gameId });
}
