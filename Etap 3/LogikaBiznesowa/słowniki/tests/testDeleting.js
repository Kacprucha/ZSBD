use('steam_games_db');

db.games.updateOne(
  { _id: 904410 },
  {  $addToSet: { developer_ids: ObjectId('6919cdd48bcb478596af54b2') } }
);

deleteDictionaryItem ('developers', ObjectId("6919cdd48bcb478596af54b2"));