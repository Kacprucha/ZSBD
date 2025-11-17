function updateGame(gameId, updateData) {
  if (!gameId) {
    throw new Error("Game ID is necessary");
  }
  
  delete updateData._id;
  
  if (updateData.price) {
    if (updateData.price.final > updateData.price.initial) {
      throw new Error("Final price cannot be greater than initial price");
    }
  }
  
  updateData.updated_at = new Date();
  
  return db.games.updateOne(
    { _id: gameId },
    { $set: updateData }
  );
}
