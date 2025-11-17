use('steam_games_db');

function addDeveloper(name) {
  return addDictionaryItem('developers', name);
}

addDeveloper("Fish Games")

const result = db.developers.findOne({name: "Fish Games"});
console.log(result);

addDeveloper("Fish Games")