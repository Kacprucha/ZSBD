use('steam_games_db');

const beforeUpdate = db.reviews.findOne({ _id: 203702268 }, { votes: 1, _id: 0 });
console.log("Before updates:");
console.log(beforeUpdate);

changeUpvoteToReview(203702268, 20)
changeFunnyVoteToReview(203702268, 5)

const review = db.reviews.findOne({ _id: 203702268 }, { votes: 1, _id: 0 });
console.log(review);

changeCommentCount(203702268, 3);
const updatedReviewAfterComments = db.reviews.findOne({ _id: 203702268 }, { votes: 1, _id: 0 });
console.log(updatedReviewAfterComments);

changeUpvoteToReview(203702268, -1000)
const updatedReview = db.reviews.findOne({ _id: 203702268 }, { votes: 1, _id: 0 });
console.log(updatedReview);