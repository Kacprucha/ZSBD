// tests/games/test_by_genre.js

import { connect, disconnect } from '../lib/database.js';
import { AggregationLibrary } from '../lib/aggregations.js';
import { ObjectId } from 'mongodb';

async function main() {
  try {
    const db = await connect();
    const agg = new AggregationLibrary(db);
    
    const sampleGenre = await db.collection('genres').findOne({_id: new ObjectId("6911bfb6eca131f353647d6c")});
    
    console.log(`\nTest genre: ${sampleGenre.name} (${sampleGenre._id})\n`);
    
    const results1 = await agg.games.byGenre(sampleGenre._id);
    console.log(`Found ${results1.length} games in ganre "${sampleGenre.name}"\n`);
    
    console.log('First 10 games in genre:\n');
    results1.slice(0, 10).forEach((game, idx) => {
      console.log(`${idx + 1}. ${game.name}`);
      console.log(`\tID: ${game._id}`);
      console.log(`\tType: ${game.type}`);
      console.log(`\tGenre: ${game.genres.join(', ')}`);
      if (game.price) {
        console.log(`\tPricw: $${(game.price.final / 100).toFixed(2)}`);
      }
      console.log();
    });
    
  } catch (error) {
    console.error('Error:', error.message);
    console.error(error.stack);
  } finally {
    await disconnect();
  }
}

main();
