function addDictionaryItem(collectionName, name) {
  if (!collectionName) {
    throw new Error("Collection name is required");
  }
  
  if (!name || typeof name !== 'string') {
    throw new Error("Element name must be a non-null string");
  }
  
  name = name.trim();
  
  if (name.length === 0) {
    throw new Error("Element name cannot be empty");
  }
  
  if (name.length > 120) {
    throw new Error("Element name cannot be longer then 120 characters");
  }
  
  const existing = db[collectionName].findOne({ 
    name: { $regex: new RegExp(`^${name}$`, 'i') } 
  });
  
  if (existing) {
    return {
      success: false,
      error: "DUPLICATE",
      message: `Element '${name}' alredy exists in ${collectionName}`,
      existingId: existing._id,
      existingName: existing.name
    };
  }
  
  try {
    const result = db[collectionName].insertOne({ name });
    
    return {
      success: true,
      insertedId: result.insertedId,
      name: name,
      message: `Element '${name}' successfully added to ${collectionName}`
    };
    
  } catch (e) {
    return {
      success: false,
      error: "DATABASE_ERROR",
      message: "Failed to add element to the database",
      technicalError: e.message
    };
  }
}
