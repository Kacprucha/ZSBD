// tests/reviews/test_by_language.js

import { connect, disconnect } from '../lib/database.js';
import { AggregationLibrary } from '../lib/aggregations.js';

async function main() {
  try {
    const db = await connect();
    const agg = new AggregationLibrary(db);
    
    console.log('\nReviews statistics by language \n');
    const results = await agg.reviews.byLanguage();
        
    console.log('Language ranking:\n');
    results.forEach((lang, idx) => {
      const avgHours = (lang.avg_playtime / 60).toFixed(2);
      console.log(`${idx + 1}. ${lang._id}`);
      console.log(`\tNumber of reviews: ${lang.count}`);
    });
    
    console.log('Statystics\n');
    const totalReviews = results.reduce((sum, lang) => sum + lang.count, 0);
    const topLanguage = results[0];
    
    console.log(`Total number of reviews: ${totalReviews}`);
    console.log(`Most popular language: ${topLanguage._id} (${topLanguage.count} reviews)`);
    console.log(`Percent: ${((topLanguage.count / totalReviews) * 100).toFixed(2)}%\n`);
    
    console.log('Top 5 languages\n');
    results.slice(0, 5).forEach((lang, idx) => {
      const percentage = ((lang.count / totalReviews) * 100).toFixed(2);
      console.log(`${idx + 1}. ${lang._id}: ${lang.count} (${percentage}%)`);
    });

    
  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    await disconnect();
  }
}

main();
