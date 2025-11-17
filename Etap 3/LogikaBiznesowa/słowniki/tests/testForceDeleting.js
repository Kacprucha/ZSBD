use('steam_games_db');

const beforDelete = db.games.findOne(
  { _id: 904410 },
  {  developer_ids: 1 }
);
console.log('Before delate:', beforDelete);

deleteDictionaryItem ('developers', ObjectId("691a1aedd8ed76a6da33612b"), true);

const afterDelete = db.games.findOne(
  { _id: 904410 },
  {  developer_ids: 1 }
);
console.log('After delate:', afterDelete);

const developer = db.developers.findOne(
  { _id: ObjectId("691a1aedd8ed76a6da33612b") }
);
console.log('Developer:', developer);