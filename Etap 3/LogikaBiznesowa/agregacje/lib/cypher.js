import { MongoClient, ClientEncryption } from "mongodb";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const uri = "mongodb://localhost:27017/?directConnection=true";
const client = new MongoClient(uri);

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const masterKeyPath = path.join(__dirname, "../crypto/master-key.bin");
const localMasterKey = fs.readFileSync(masterKeyPath);

const kmsProviders = {
  local: {
    key: localMasterKey
  }
};

const encryption = new ClientEncryption(client, {
  keyVaultNamespace: "encryption.__keyVault",
  kmsProviders
});

const dataKeyId = await encryption.createDataKey("local", {
  keyAltNames: ["steamidKey"]
});

const encryptedSteamId = await encryption.encrypt(
  "76561198000000001",
  {
    algorithm: "AEAD_AES_256_CBC_HMAC_SHA_512-Deterministic",
    keyId: dataKeyId
  }
);

const reviews = client.db("steam_games_db").collection("reviews");

await reviews.insertOne({
  _id: 123456,
  appid: 904410,
  language: "english",
  text: "Encrypted steamid test",
  is_positive: true,
  author: {
    steamid: encryptedSteamId,
    num_games_owned: 120,
    num_reviews: 5,
    playtime_forever: 2400
  },
  votes: { up: 0, funny: 0, weighted_score: 0.5, comment_count: 0 },
  context: {
    steam_purchase: true,
    received_for_free: false,
    written_during_early_access: false
  },
  timestamps: {
    created: new Date(),
    updated: new Date()
  },
  hidden: false,
  flagged: false
});

const doc = await reviews.findOne({ _id: 123456 });
const decryptedSteamId = await encryption.decrypt(doc.author.steamid);
console.log("Decrypted steamid:", decryptedSteamId.toString());
