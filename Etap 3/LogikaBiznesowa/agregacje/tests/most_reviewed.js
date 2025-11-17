import { connect, disconnect } from '../lib/database.js';
import { AggregationLibrary } from '../lib/aggregations.js';

async function main() {
  try {
    const db = await connect();
    const agg = new AggregationLibrary(db);
    
    console.log('\nTop 10 most popular games\n');
    const results1 = await agg.reviews.mostReviewed();
        
    results1.forEach((game, idx) => {
      console.log(`${idx + 1}. ${game.game_name}`);
      console.log(`\tTotal reviws: ${game.total_reviews}`);
      console.log(`\tPositive: ${game.positive_percentage}%`);
      console.log(`\tAvrage play time: ${game.avg_playtime_hours}h\n`);
    });
    
  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    await disconnect();
  }
}

main();
