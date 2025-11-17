function deleteDictionaryItem(collectionName, itemId, force = false) {
  if (!collectionName || !itemId) {
    throw new Error("collectionName and itemId are required");
  }
  
  if (typeof itemId === 'string') {
    itemId = ObjectId(itemId);
  }
  
  const item = db[collectionName].findOne({ _id: itemId });
  if (!item) {
    return {
      success: false,
      error: "NOT_FOUND",
      message: `Element of ID ${itemId} not existing in ${collectionName}`
    };
  }
  
  const fieldMapping = {
    'developers': 'developer_ids',
    'publishers': 'publisher_ids',
    'genres': 'genre_ids',
    'categories': 'category_ids'
  };
  
  const fieldName = fieldMapping[collectionName];
  if (!fieldName) {
    return {
      success: false,
      error: "INVALID_COLLECTION",
      message: `Elemts od ${collectionName} are not supported for deletion by this function`
    };
  }
  
  const usageCount = db.games.countDocuments({
    [fieldName]: itemId
  });
  
  if (usageCount > 0 && !force) {
    return {
      success: false,
      error: "IN_USE",
      message: `Element '${item.name}' exists in ${usageCount} game documents`,
      usageCount: usageCount,
      itemName: item.name,
      hint: "Use force=true to delete the element and remove all references from games"
    };
  }
  
  try {
    const result = db[collectionName].deleteOne({ _id: itemId });
    
    if (force && usageCount > 0) {
      const cleanupResult = db.games.updateMany(
        { [fieldName]: itemId },
        { $pull: { [fieldName]: itemId } }
      );
      
      return {
        success: true,
        deletedCount: result.deletedCount,
        itemName: item.name,
        gamesUpdated: cleanupResult.modifiedCount,
        message: `Element '${item.name}' delated with ${cleanupResult.modifiedCount} references`
      };
    }
    
    return {
      success: true,
      deletedCount: result.deletedCount,
      itemName: item.name,
      message: `Element '${item.name}' successfully deleted`
    };
    
  } catch (e) {
    return {
      success: false,
      error: "DATABASE_ERROR",
      message: "Failed to delete element",
      technicalError: e.message
    };
  }
}
