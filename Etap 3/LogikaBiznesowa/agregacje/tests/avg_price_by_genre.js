// tests/games/test_avg_price_by_genre.js

import { connect, disconnect } from '../lib/database.js';
import { AggregationLibrary } from '../lib/aggregations.js';

async function main() {
  try {
    const db = await connect();
    const agg = new AggregationLibrary(db);
    
    console.log('\nAvrage price by genre\n');
    const results = await agg.games.avgPriceByGenre();


        
    console.log('Avrage price ranking top 10:\n');
    results.slice(0, 10).forEach((genre, idx) => {
      console.log(`${idx + 1}. ${genre.genre}`);
      console.log(`\tAvrage proce: $${genre.avg_price_usd}`);
      console.log(`\tNumber of games: ${genre.games_count}\n`);
    });
    
    console.log('Statystics\n');
    const prices = results.map(g => g.avg_price_usd);
    const avgPrice = (prices.reduce((a, b) => a + b, 0) / prices.length).toFixed(2);
    const maxPrice = Math.max(...prices);
    const minPrice = Math.min(...prices);
    
    console.log(`Avrage proce of all genres: $${avgPrice}`);
    console.log(`Most expensice ganre: $${maxPrice}`);
    console.log(`The cheapest gebre: $${minPrice}\n`);
    
  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    await disconnect();
  }
}

main();
