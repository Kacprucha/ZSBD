function flagReviewAsInappropriate(reviewId, reason) {
  return db.reviews.updateOne(
    { _id: reviewId },
    { 
      $set: { 
        "moderation.flagged": true,
        "moderation.flag_reason": reason,
        "moderation.flagged_at": new Date(),
        "timestamps.updated": new Date()
      }
    }
  );
}

function hideReview(reviewId) {
  return db.reviews.updateOne(
    { _id: reviewId },
    { 
      $set: { 
        "moderation.hidden": true,
        "moderation.hidden_at": new Date(),
        "timestamps.updated": new Date()
      }
    }
  );
}

function unhideReview(reviewId) {
  return db.reviews.updateOne(
    { _id: reviewId },
    { 
      $set: { 
        "moderation.hidden": false,
        "moderation.flagged": false,
        "timestamps.updated": new Date()
      },
      $unset: { 
        "moderation.hidden_at": "",
        "moderation.flag_reason": "",
        "moderation.flagged_at": ""
      }
    }
  );
}
