use('steam_games_db');

addCategoryToGame(3996191, "6911bfb6eca131f353647dd4");

const result = db.games.find(
  { _id: 3996191 }, 
  { _id: 1, 
    "category_ids": 1
  }).toArray();

console.log(result);

removeCategoryFromGame(3996191, "6911bfb6eca131f353647dd4");

const result2 = db.games.find(
  { _id: 3996191 }, 
  { _id: 1, 
    "category_ids": 1
  }).toArray();

console.log(result2);