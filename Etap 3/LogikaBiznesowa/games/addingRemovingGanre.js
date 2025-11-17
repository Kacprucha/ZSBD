function addCategoryToGame(gameId, genreId) {
  return db.games.updateOne(
    { _id: gameId },
    { 
      $addToSet: { 
        category_ids: ObjectId(genreId) 
      },
      $set: { updated_at: new Date() }
    }
  );
}

function removeCategoryFromGame(gameId, genreId) {
  return db.games.updateOne(
    { _id: gameId },
    { 
      $pull: { 
        category_ids: ObjectId(genreId) 
      },
      $set: { updated_at: new Date() }
    }
  );
}