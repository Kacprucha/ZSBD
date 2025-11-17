function addGame(gameData) {
  gameData._id = getNextSequence("game_id");
  
  gameData.type = gameData.type || "game";
  gameData.is_free = gameData.is_free || false;
  gameData.required_age = gameData.required_age || 0;
  gameData.achievement_count = gameData.achievement_count || 0;
  
  gameData.supported_languages = gameData.supported_languages || [];
  gameData.developer_ids = gameData.developer_ids || [];
  gameData.publisher_ids = gameData.publisher_ids || [];
  gameData.genre_ids = gameData.genre_ids || [];
  gameData.category_ids = gameData.category_ids || [];
  
  if (gameData.price) {
    if (gameData.price.final > gameData.price.initial) {
      throw new Error("Final price cannot be greater than initial price");
    }
  }
  
  return db.games.insertOne(gameData);
}