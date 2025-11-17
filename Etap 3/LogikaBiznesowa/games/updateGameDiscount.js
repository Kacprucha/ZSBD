function updateGamePrice(gameId, newPrice, discountPercent = 0) {
  if (!gameId) {
    throw new Error("Game ID is necessary");
  }
  
  if (newPrice < 0) {
    throw new Error("Price cannot be negative");
  }
  
  if (discountPercent < 0 || discountPercent > 100) {
    throw new Error("Discount percent must be between 0 and 100");
  }
  
  const finalPrice = Math.round(newPrice * (100 - discountPercent) / 100);
  
  return db.games.updateOne(
    { _id: gameId },
    { 
      $set: { 
        "price.initial": newPrice,
        "price.final": finalPrice,
        "price.discount_percent": discountPercent,
        updated_at: new Date()
      }
    }
  );
}
