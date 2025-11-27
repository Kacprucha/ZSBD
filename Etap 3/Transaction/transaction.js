use('steam_games_db');

const gameId = 904410;
const newReviewId = getNextSequence("review_id");

const befereUpdateGame = db.games.findOne({ _id: gameId }, { _id: 1, reception: 1 });
console.log("Game stats before update:", befereUpdateGame);

const session = db.getMongo().startSession();
const reviews = session.getDatabase('steam_games_db').reviews;
const games   = session.getDatabase('steam_games_db').games;

try {
  session.startTransaction({
    readConcern:  { level: "snapshot" },
    writeConcern: { w: "majority" }
  });

  const reviewToInsert = {
    _id: newReviewId,
    appid: gameId,
    language: "english",
    text: "Great game, love the mechanics!",
    is_positive: true,
    author: {
      steamid: NumberLong("76561198000000001"),
      num_games_owned: 120,
      num_reviews: 5,
      playtime_forever: 2400,
      playtime_at_review: 2000
    },
    votes: {
      up: 0,
      funny: 0,
      weighted_score: 0.0,
      comment_count: 0
    },
    context: {
      steam_purchase: true,
      received_for_free: false,
      written_during_early_access: false
    },
    timestamps: {
      created: new Date(),
      updated: new Date()
    },
    hidden: false,
    flagged: false
  };

  reviews.insertOne(reviewToInsert);

  games.updateOne(
    { _id: gameId },
    { 
      $inc: { "reception.recommendations_total": 1 },
      $set: { updated_at: new Date() }
    }
  );

  session.commitTransaction();
  print("\tTransaction committed (review + game stats)");

} catch (e) {
  print("\tTransaction aborted:", e.message);
  
  session.abortTransaction();
} finally {
  session.endSession();
}

const newReview = db.reviews.findOne({ _id: newReviewId });
console.log("Newly inserted review:", newReview);

const updatedGame = db.games.findOne({ _id: 904410 }, {reception: 1});
console.log("Updated game stats:", updatedGame);
