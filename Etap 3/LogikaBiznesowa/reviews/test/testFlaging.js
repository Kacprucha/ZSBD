use('steam_games_db');

flagReviewAsInappropriate(203702268, "Inappropriate content");

const flagedReview = db.reviews.findOne({ _id: 203702268 }, { moderation: 1, _id: 0 });
console.log("Flaged review:", flagedReview);

hideReview(203702268);

const hiddenReview = db.reviews.findOne({ _id: 203702268 }, { moderation: 1, _id: 0 });
console.log("Hidden review:", hiddenReview);

unhideReview(203702268);

const unhiddenReview = db.reviews.findOne({ _id: 203702268 }, { moderation: 1, _id: 0 });
console.log("Unhidden review:", unhiddenReview);
