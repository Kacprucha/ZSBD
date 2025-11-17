function recalculateWeightedScore(reviewId) {
  const review = db.reviews.findOne({ _id: reviewId });
  
  if (!review) {
    throw new Error("Review not found");
  }
  
  const upVotes = review.votes.up || 0;
  const totalVotes = upVotes + (review.votes.funny || 0);
  
  let weightedScore = 0.0;
  if (totalVotes > 0) {
    const z = 1.96; 
    const phat = upVotes / totalVotes;
    weightedScore = (phat + z*z/(2*totalVotes) - z * Math.sqrt((phat*(1-phat)+z*z/(4*totalVotes))/totalVotes))/(1+z*z/totalVotes);
  }
  
  return db.reviews.updateOne(
    { _id: reviewId },
    { 
      $set: { 
        "votes.weighted_score": weightedScore,
        "timestamps.updated": new Date()
      }
    }
  );
}
