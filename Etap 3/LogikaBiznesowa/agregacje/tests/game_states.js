import { connect, disconnect } from '../lib/database.js';
import { AggregationLibrary } from '../lib/aggregations.js';

async function main() {
  try {
    const db = await connect();
    
    const agg = new AggregationLibrary(db);
    
    console.log('\nTop 10 games by number of reviews\n');
    
    const results = await agg.reviews.gameStats({ 
      limit: 10,
      sortField: 'total_reviews',
      sortOrder: -1
    });
    
    results.forEach((game, idx) => {
      console.log(`${idx + 1}. ${game.game_name}`);
      console.log(`\tID: ${game._id}`);
      console.log(`\tReviews: ${game.total_reviews} (${game.positive_percentage}% positive)`);
      console.log(`\tPositive: ${game.positive_reviews}, Negative: ${game.negative_reviews}`);
      console.log(`\tAvrage game time: ${game.avg_playtime_hours}h\n`);
    });
    
  } catch (error) {
    console.error('Error:', error);
  } finally {
    await disconnect();
  }
}

main();
