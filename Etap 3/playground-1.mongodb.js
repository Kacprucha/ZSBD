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

function getNextSequence(sequenceName) {
  const sequenceDocument = db.counters.findAndModify({
    query: { _id: sequenceName },
    update: { $inc: { seq: 1 } },
    new: true,
    upsert: true
  });
  return sequenceDocument.seq;
}

// Select the database to use.
use('steam_games_db');

db.runCommand({
  collMod: "reviews",
  validator: {
    $jsonSchema: {
      bsonType: "object",
      additionalProperties: true,
      required: ["_id", "appid", "language", "text", "is_positive", "author", "votes", "context", "timestamps"],
      properties: {
        _id: {
          bsonType: "int",
          description: "Review ID necessary, type integer"
        },
        appid: {
          bsonType: "int",
          description: "Game ID necessary, reference to document in games collection"
        },
        language: {
          bsonType: "string",
          enum: ["english", "polish", "german", "french", "spanish", "russian", "chinese", "japanese"],
          description: "Lnguage of the review - required"
        },
        text: {
          bsonType: "string",
          minLength: 1,
          maxLength: 50000,
          description: "Review content necessary, 1-50000 characters"
        },
        is_positive: {
          bsonType: "bool",
          description: "Is the review positive or negative necessary"
        },
        author: {
          bsonType: "object",
          required: ["steamid", "num_games_owned", "num_reviews", "playtime_forever"],
          properties: {
            steamid: {
              bsonType: ["long", "string", "binData"],
              description: "Steam ID of the author"
            },
            num_games_owned: {
              bsonType: "int",
              minimum: 0,
              description: "Number of games owned by the author - minimum 0"
            },
            num_reviews: {
              bsonType: "int",
              minimum: 0,
              description: "Number of reviews written by the author - minimum 0"
            },
            playtime_forever: {
              bsonType: "int",
              minimum: 0,
              description: "Total playtime of the author - minimum 0"
            },
            playtime_last_two_weeks: {
              bsonType: "int",
              minimum: 0,
              description: "Playtime in the last two weeks - minimum 0"
            },
            playtime_at_review: {
              bsonType: "int",
              minimum: 0,
              description: "Playtime at the time of review - minimum 0"
            },
            last_played: {
              bsonType: "date",
              description: "Last played date"
            }
          }
        },
        votes: {
          bsonType: "object",
          required: ["up", "funny", "weighted_score", "comment_count"],
          properties: {
            up: {
              bsonType: "int",
              minimum: 0,
              description: "Number of upvotes - minimum 0"
            },
            funny: {
              bsonType: "int",
              minimum: 0,
              description: "Number of funny votes - minimum 0"
            },
            weighted_score: {
              bsonType: ["double", "int"],
              minimum: 0,
              maximum: 1,
              description: "Weighted score from 0 to 1"
            },
            comment_count: {
              bsonType: "int",
              minimum: 0,
              description: "Number of comments - minimum 0"
            }
          }
        },
        context: {
          bsonType: "object",
          required: ["steam_purchase", "received_for_free", "written_during_early_access"],
          properties: {
            steam_purchase: {
              bsonType: "bool",
              description: "Is it a Steam purchase"
            },
            received_for_free: {
              bsonType: "bool",
              description: "Is it received for free"
            },
            written_during_early_access: {
              bsonType: "bool",
              description: "Is it written during early access"
            }
          }
        },
        timestamps: {
          bsonType: "object",
          required: ["created", "updated"],
          properties: {
            created: {
              bsonType: "date",
              description: "Date of creation"
            },
            updated: {
              bsonType: "date",
              description: "Date of last update"
            }
          }
        }
      }
    }
  },
  validationLevel: "moderate",
  validationAction: "error"
});