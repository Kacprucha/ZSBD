import { ReviewsAggregations } from './reviews.js';
import { GamesAggregations } from './games.js';

export class AggregationLibrary {
  constructor(db) {
    this.db = db;
    this.reviews = new ReviewsAggregations(db);
    this.games = new GamesAggregations(db);
  }
}

export { ReviewsAggregations, GamesAggregations };
