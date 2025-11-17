import { connect, disconnect } from '../lib/database.js';
import { AggregationLibrary } from '../lib/aggregations.js';

async function main() {
  try {
    const db = await connect();
    const agg = new AggregationLibrary(db);
    
    console.log('\nTop 10 hight reviewd games \n');
    
    const results = await agg.reviews.topRated(10, 10);
    
    results.forEach((game, idx) => {
      console.log(`${idx + 1}. ${game.game_name}`);
      console.log(`\tPositive reviews: ${game.positive_percentage}%`);
      console.log(`\tNumber of reviews: ${game.total_reviews}\n`);
    });
    
  } catch (error) {
    console.error('Error:', error);
  } finally {
    await disconnect();
  }
}

main();
