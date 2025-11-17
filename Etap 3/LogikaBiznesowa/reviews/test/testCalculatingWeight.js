use('steam_games_db');

const newReviewData = {
  _id: getNextSequence("review_id"),
  appid: 427520,
  language: "english",
  text: "After 5000 hours, I can finally say I'm ready for the tutorial. This game is a masterpiece of competitive gameplay. Highly recommended if you have a lot of free time and patience.",
  is_positive: true,
  author: {
    steamid: 76561198000000001n,
    num_games_owned: 250,
    num_reviews: 15,
    playtime_forever: 300000,
    playtime_last_two_weeks: 3000,
    playtime_at_review: 250000,
    last_played: new Date()
  },
  votes: {
    up: 2548,
    funny: 120,
    weighted_score: 0.1,
    comment_count: 89
  },
  context: {
    steam_purchase: true,
    received_for_free: false,
    written_during_early_access: false
  },
  timestamps: {
    created: new Date(),
    updated: new Date()
  }
}

const insertResult = db.reviews.insertOne(newReviewData);
console.log("Review added with ID:", insertResult.insertedId);

recalculateWeightedScore(newReviewData._id);

db.reviews.find({ _id: newReviewData._id }, {_id: 1, "votes.weighted_score": 1}).pretty();