use('steam_games_db');

const maxGameId = db.games.find({}, {_id:1}).sort({_id:-1}).limit(1).pretty().toArray()[0]['_id'];

const maxReviewId = db.reviews.find({}, {_id:1}).sort({_id:-1}).limit(1).pretty().toArray()[0]['_id'];

db.counters.drop();
db.createCollection("counters");

db.counters.insertMany([
  { _id: "review_id", seq: maxReviewId },
  { _id: "game_id", seq: maxGameId }
]);

function getNextSequence(sequenceName) {
  const sequenceDocument = db.counters.findAndModify({
    query: { _id: sequenceName },
    update: { $inc: { seq: 1 } },
    new: true,
    upsert: true
  });
  return sequenceDocument.seq;
}