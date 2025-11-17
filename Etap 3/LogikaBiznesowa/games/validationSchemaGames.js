use('steam_games_db');

db.runCommand({
  collMod: "games",
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["_id", "name", "type"],
      additionalProperties: true,
      properties: {
        _id: {
          bsonType: "int",
          description: "Game ID is necessary, type integer"
        },
        name: {
          bsonType: "string",
          minLength: 1,
          maxLength: 500,
          description: "Game name is necessary, 1-500 characters"
        },
        type: {
          enum: ["game", "dlc", "demo", "mod"],
          description: "Product type necessary"
        },
        is_free: {
          bsonType: "bool",
          description: "Is game free or not"
        },
        release_date: {
          bsonType: ["date", "null"],
          description: "Relace date necessary could be null"
        },
        required_age: {
          bsonType: "int",
          minimum: 0,
          maximum: 21,
          description: "Age necessary form 0 to 21"
        },
        description: {
          bsonType: "string",
          maxLength: 10000,
          description: "Game description - maximum 10000 characters"
        },
        supported_languages: {
          bsonType: "array",
          items: {
            bsonType: "string"
          },
          description: "List of supported languages"
        },
        achievement_count: {
          bsonType: "int",
          minimum: 0,
          description: "Number of achievements - minimum 0"
        },
        media: {
          bsonType: "object",
          properties: {
            header_image: {
              bsonType: "string",
              pattern: "^https?://.*",
              description: "URL to header image"
            },
            background: {
              bsonType: "string",
              pattern: "^https?://.*",
              description: "URL to background image"
            }
          }
        },
        reception: {
          bsonType: "object",
          properties: {
            metacritic_score: {
              bsonType: "int",
              minimum: 0,
              maximum: 100,
              description: "Metacritic score form 0 to 100"
            },
            recommendations_total: {
              bsonType: "double",
              minimum: 0,
              description: "Summary number of recommendations"
            }
          }
        },
        price: {
          bsonType: "object",
          properties: {
            initial: {
              bsonType: "int",
              minimum: 0,
              description: "Beginning price in cents"
            },
            final: {
              bsonType: "int",
              minimum: 0,
              description: "Final price in cents"
            },
            discount_percent: {
              bsonType: "int",
              minimum: 0,
              maximum: 100,
              description: "Discount percent form 0 to 100"
            },
            currency: {
              bsonType: "string",
              enum: ["USD", "EUR", "GBP", "PLN"],
              description: "Currency code"
            }
          }
        },
        platforms: {
          bsonType: "object",
          properties: {
            windows: { bsonType: "bool" },
            mac: { bsonType: "bool" },
            linux: { bsonType: "bool" }
          }
        },
        requirements: {
          bsonType: "object",
          description: "System requirements for different platforms",
          properties: {
            pc: {
              bsonType: "object",
              properties: {
                minimum: {
                  bsonType: "object",
                  description: "Minimum PC requirements"
                },
                recommended: {
                  bsonType: "object",
                  description: "Recommended PC requirements"
                }
              }
            },
            mac: {
              bsonType: "object",
              properties: {
                minimum: {
                  bsonType: "object",
                  description: "Minimum Mac requirements"
                },
                recommended: {
                  bsonType: "object",
                  description: "Recommended Mac requirements"
                }
              }
            },
            linux: {
              bsonType: "object",
              properties: {
                minimum: {
                  bsonType: "object",
                  description: "Minimum Linux requirements"
                },
                recommended: {
                  bsonType: "object",
                  description: "Recommended Linux requirements"
                }
              }
            }
          }
        },
        developer_ids: {
          bsonType: "array",
          items: {
            bsonType: "objectId"
          }
        },
        publisher_ids: {
          bsonType: "array",
          items: {
            bsonType: "objectId"
          }
        },
        genre_ids: {
          bsonType: "array",
          items: {
            bsonType: "objectId"
          }
        },
        category_ids: {
          bsonType: "array",
          items: {
            bsonType: "objectId"
          }
        },
        created_at: {
          bsonType: "date",
          description: "Creation timestamp"
        }
      }
    }
  },
  validationLevel: "moderate",
  validationAction: "error"
});
