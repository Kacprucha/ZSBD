import { ObjectId } from 'mongodb';

export class ReviewsAggregations {
  constructor(db) {
    this.db = db;
    this.collection = db.collection('reviews');
  }

  async gameStats(options = {}) {
    const {
      limit = 50,
      sortField = 'total_reviews',
      sortOrder = -1
    } = options;
    
    const sortObj = {};
    sortObj[sortField] = sortOrder;
    
    return await this.collection.aggregate([
      {
        $group: {
          _id: "$appid",
          total_reviews: { $sum: 1 },
          positive_reviews: {
            $sum: { $cond: ["$is_positive", 1, 0] }
          },
          negative_reviews: {
            $sum: { $cond: ["$is_positive", 0, 1] }
          },
          avg_playtime_at_review: { 
            $avg: "$author.playtime_at_review" 
          }
        }
      },
      {
        $addFields: {
          positive_percentage: {
            $multiply: [
              { $divide: ["$positive_reviews", "$total_reviews"] },
              100
            ]
          }
        }
      },
      {
        $lookup: {
          from: "games",
          localField: "_id",
          foreignField: "_id",
          as: "game_info"
        }
      },
      {
        $unwind: "$game_info"
      },
      {
        $project: {
          _id: 1,
          game_name: "$game_info.name",
          total_reviews: 1,
          positive_reviews: 1,
          negative_reviews: 1,
          positive_percentage: { $round: ["$positive_percentage", 2] },
          avg_playtime_hours: { 
            $round: [{ $divide: ["$avg_playtime_at_review", 60] }, 2] 
          }
        }
      },
      {
        $sort: sortObj
      },
      {
        $limit: limit
      }
    ]).toArray();
  }

  async mostReviewed(limit = 10) {
    return await this.gameStats({ 
      limit, 
      sortField: 'total_reviews', 
      sortOrder: -1 
    });
  }

  async topRated(limit = 10, minReviews = 5) {
    return await this.collection.aggregate([
      {
        $group: {
          _id: "$appid",
          total_reviews: { $sum: 1 },
          positive_reviews: {
            $sum: { $cond: ["$is_positive", 1, 0] }
          }
        }
      },
      {
        $match: {
          total_reviews: { $gte: minReviews }
        }
      },
      {
        $addFields: {
          positive_percentage: {
            $multiply: [
              { $divide: ["$positive_reviews", "$total_reviews"] },
              100
            ]
          }
        }
      },
      {
        $lookup: {
          from: "games",
          localField: "_id",
          foreignField: "_id",
          as: "game_info"
        }
      },
      {
        $unwind: "$game_info"
      },
      {
        $project: {
          _id: 1,
          game_name: "$game_info.name",
          total_reviews: 1,
          positive_percentage: { $round: ["$positive_percentage", 2] }
        }
      },
      {
        $sort: { positive_percentage: -1 }
      },
      {
        $limit: limit
      }
    ]).toArray();
  }

  async byLanguage() {
    return await this.collection.aggregate([
      {
        $group: {
          _id: "$language",
          count: { $sum: 1 },
          avg_playtime: { $avg: "$author.playtime_forever" }
        }
      },
      {
        $sort: { count: -1 }
      }
    ]).toArray();
  }
}
