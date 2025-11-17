use('steam_games_db');

const invalidReviewData = {
  _id: getNextSequence("review_id"),
  appid: 215450,
    language: "english",
    text: "",
    is_positive: true,
    author: {
      steamid: NumberLong("76561197960287939"),
      num_games_owned: 10,
      num_reviews: 1,
      playtime_forever: 100
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
    }
}

try {
const result = db.reviews.insertOne(invalidReviewData);
}
catch (e) {
  console.log("Error inserting review:", e.message);
}