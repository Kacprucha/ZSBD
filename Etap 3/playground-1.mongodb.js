/* global use, db */
// MongoDB Playground
// To disable this template go to Settings | MongoDB | Use Default Template For Playground.
// Make sure you are connected to enable completions and to be able to run a playground.
// Use Ctrl+Space inside a snippet or a string literal to trigger completions.
// The result of the last command run in a playground is shown on the results panel.
// By default the first 20 documents will be returned with a cursor.
// Use 'console.log()' to print to the debug output.
// For more documentation on playgrounds please refer to
// https://www.mongodb.com/docs/mongodb-vscode/playgrounds/

// Select the database to use.
use('steam_games_db');

load('LogikaBiznesowa/agregacje/aggregation_library.js');

const topReviewedGames = aggregationLibrary.games.mostReviewed(5);
console.log('Top 5 Most Reviewed Games:', topReviewedGames);

const avgPriceByGenre = aggregationLibrary.games.avgPriceByGenre();
console.log('Average Price by Genre:', avgPriceByGenre);

const genreId = '6911bfb6eca131f353647dc6'; // RPG 
const gamesByGenre = aggregationLibrary.games.byGenre(genreId);
console.log(`Games in Genre ${genreId}:`, gamesByGenre);

const biggestDiscounts = aggregationLibrary.games.biggestDiscounts(5);
console.log('Top 5 Biggest Discounts:', biggestDiscounts);

const top50Games = AggregationLibrary.reviews.gameStats({ limit: 50 });
printjson(top50Games);

const mostReviewed = AggregationLibrary.reviews.mostReviewed(10);
printjson(mostReviewed);

const topRated = AggregationLibrary.reviews.topRated(20, 10);
printjson(topRated);

const langStats = AggregationLibrary.reviews.byLanguage();
printjson(langStats);

const pricesByGenre = AggregationLibrary.games.avgPriceByGenre();
printjson(pricesByGenre);
