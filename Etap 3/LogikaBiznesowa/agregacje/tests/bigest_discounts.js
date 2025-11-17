// tests/games/test_biggest_discounts.js

import { connect, disconnect } from '../lib/database.js';
import { AggregationLibrary } from '../lib/aggregations.js';

async function main() {  
  try {
    const db = await connect();
    const agg = new AggregationLibrary(db);
    
    console.log('\nTop 10 bigest discounts\n');
    const results1 = await agg.games.biggestDiscounts();
        
    results1.forEach((game, idx) => {
      const initialPrice = (game.price.initial / 100).toFixed(2);
      const finalPrice = (game.price.final / 100).toFixed(2);
      const discount = game.price.discount_percent;
      
      console.log(`${idx + 1}. ${game.name}`);
      console.log(`\tDiscount: ${discount}%`);
      console.log(`\tPrice: $${initialPrice} → $${finalPrice}`);
      console.log(`\tHow much you save: $${(initialPrice - finalPrice).toFixed(2)}\n`);
    });
    
  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    await disconnect();
  }
}

main();
