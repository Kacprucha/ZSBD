import { ObjectId } from 'mongodb';

export class GamesAggregations {
  constructor(db) {
    this.db = db;
    this.collection = db.collection('games');
  }

  async byGenre(genreId) {
    const genreObjectId = typeof genreId === 'string' 
      ? new ObjectId(genreId) 
      : genreId;
    
    return await this.collection.aggregate([
      {
        $match: {
          genre_ids: genreObjectId
        }
      },
      {
        $lookup: {
          from: "genres",
          localField: "genre_ids",
          foreignField: "_id",
          as: "genres"
        }
      },
      {
        $project: {
          _id: 1,
          name: 1,
          type: 1,
          price: 1,
          genres: "$genres.name"
        }
      }
    ]).toArray();
  }

  async avgPriceByGenre() {
    return await this.collection.aggregate([
      {
        $match: {
          "price.final": { $gt: 0 }
        }
      },
      {
        $unwind: "$genre_ids"
      },
      {
        $group: {
          _id: "$genre_ids",
          avg_price: { $avg: "$price.final" },
          count: { $sum: 1 }
        }
      },
      {
        $lookup: {
          from: "genres",
          localField: "_id",
          foreignField: "_id",
          as: "genre_info"
        }
      },
      {
        $unwind: "$genre_info"
      },
      {
        $project: {
          _id: 0,
          genre: "$genre_info.name",
          avg_price_usd: { 
            $round: [{ $divide: ["$avg_price", 100] }, 2] 
          },
          games_count: "$count"
        }
      },
      {
        $sort: { avg_price_usd: -1 }
      }
    ]).toArray();
  }

  async biggestDiscounts(limit = 10) {
    return await this.collection.aggregate([
      {
        $match: {
          "price.discount_percent": { $gt: 0 }
        }
      },
      {
        $project: {
          _id: 1,
          name: 1,
          price: 1
        }
      },
      {
        $sort: { "price.discount_percent": -1 }
      },
      {
        $limit: limit
      }
    ]).toArray();
  }
}
