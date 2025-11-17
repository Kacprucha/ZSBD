import { MongoClient } from 'mongodb';
import { dbConfig } from '../config/database.js';

let client = null;
let db = null;

export async function connect() {
  if (db) {
    return db;
  }
  
  try {
    client = new MongoClient(dbConfig.url, dbConfig.options);
    await client.connect();
    db = client.db(dbConfig.dbName);
    console.log(`Conected with db: ${dbConfig.dbName}`);
    return db;
  } catch (error) {
    console.error('Error when connecting:', error);
    throw error;
  }
}

export async function disconnect() {
  if (client) {
    await client.close();
    client = null;
    db = null;
    console.log('Disconnected from database');
  }
}

export function getDb() {
  if (!db) {
    throw new Error('There is no database connection.');
  }
  return db;
}
