use('steam_games_db');

const appid = 1091500;

db.reviews.aggregate([
  { $match: { appid: appid } },
  {
    $facet: {
      by_sentiment: [
        {
          $group: {
            _id: "$is_positive",
            count: { $sum: 1 }
          }
        }
      ],
      playtime_histogram: [
        {
          $bucket: {
            groupBy: "$author.playtime_at_review",   
            boundaries: [0, 60, 300, 1000, 5000, 10000], 
            default: "10000+",
            output: {
              count: { $sum: 1 }
            }
          }
        }
      ],
      playtime_stats: [
        {
          $group: {
            _id: null,
            avg_playtime: { $avg: "$author.playtime_at_review" },
            min_playtime: { $min: "$author.playtime_at_review" },
            max_playtime: { $max: "$author.playtime_at_review" }
          }
        }
      ]
    }
  }
]).pretty();
