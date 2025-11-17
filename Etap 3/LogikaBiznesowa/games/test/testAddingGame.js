use('steam_games_db');

const newGameData = {
  name: "Example RPG Game",
  type: "game",
  is_free: false,
  release_date: new Date("2025-03-15"),
  required_age: 12,
  description: "An epic RPG adventure...",
  supported_languages: ["English", "Polish", "German"],
  achievement_count: 50,
  media: {
    header_image: "https://example.com/header.jpg",
    background: "https://example.com/bg.jpg"
  },
  price: {
    initial: 4999,
    final: 3999,
    discount_percent: 20,
    currency: "USD"
  },
  platforms: {
    windows: true,
    mac: true,
    linux: false
  },
  developer_ids: [ObjectId("6911bfafeca131f35361a314")],
  publisher_ids: [ ObjectId("6911bfb5eca131f353634089")],
  genre_ids: [
    ObjectId("6911bfb6eca131f353647d55"),
    ObjectId("6911bfb6eca131f353647dc6") 
  ]
};

const prevoius_id = db.counters.find().pretty().toArray()[1]['seq'];
console.log("Previous game_id:", prevoius_id);

const result = addGame(newGameData);
console.log("Game added with ID:", result.insertedId);

db.counters.find().pretty();