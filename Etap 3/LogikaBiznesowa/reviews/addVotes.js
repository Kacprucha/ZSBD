function changeUpvoteToReview(reviewId, ammount = 1) {
  let result = null;
  if (ammount > 0) {
    result = db.reviews.findOneAndUpdate(
      { _id: reviewId },
      { 
        $inc: { "votes.up": ammount },
        $set: { "timestamps.updated": new Date() }
      },
      { returnDocument: "after" }
    );
  }
  else {
    result = db.reviews.findOneAndUpdate(
      { _id: reviewId },
      { 
        $inc: { "votes.up": ammount },
        $set: { "timestamps.updated": new Date() }
      },
      { returnDocument: "after" }
    );
  }
  
  if (result) {
    recalculateWeightedScore(reviewId);
  }
  
  return result;
}

function changeFunnyVoteToReview(reviewId, ammount = 1) {
  let result = null;
  if (ammount > 0) {
    result = db.reviews.findOneAndUpdate(
      { _id: reviewId },
      { 
        $inc: { "votes.funny": ammount },
        $set: { "timestamps.updated": new Date() }
      },
      { returnDocument: "after" }
    );
  }
  else {
    result = db.reviews.findOneAndUpdate(
      { _id: reviewId },
      { 
        $inc: { "votes.funny": ammount },
        $set: { "timestamps.updated": new Date() }
      },
      { returnDocument: "after" }
    );
  }

  if (result) {
    recalculateWeightedScore(reviewId);
  }
  
  return result;
}

function changeCommentCount(reviewId, ammount = 1) {
  let result = null;
  if (ammount > 0) {
    result = db.reviews.updateOne(
      { _id: reviewId },
      { 
        $inc: { "votes.comment_count": ammount },
        $set: { "timestamps.updated": new Date() }
      }
    );
  }
  else {
    result = db.reviews.updateOne(
      { _id: reviewId },
      { 
        $inc: { "votes.comment_count": ammount },
        $set: { "timestamps.updated": new Date() }
      }
    );
  }

  return result;
}