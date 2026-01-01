// CZYSZCZENIE I INDEKSY 

MATCH (n) DETACH DELETE n;

CREATE CONSTRAINT card_name_unique IF NOT EXISTS FOR (c:Card) REQUIRE c.name IS UNIQUE;
CREATE CONSTRAINT deck_id_unique IF NOT EXISTS FOR (d:Deck) REQUIRE d.id IS UNIQUE;
CREATE CONSTRAINT pilot_name_unique IF NOT EXISTS FOR (p:Pilot) REQUIRE p.name IS UNIQUE;
CREATE CONSTRAINT tag_name_unique IF NOT EXISTS FOR (t:Tag) REQUIRE t.name IS UNIQUE;

CREATE INDEX archetype_name_index IF NOT EXISTS FOR (a:Archetype) ON (a.name);
CREATE INDEX event_name_index IF NOT EXISTS FOR (e:Event) ON (e.name);
CREATE INDEX card_price_index IF NOT EXISTS FOR (c:Card) ON (c.priceUsd);
CREATE INDEX budget_name_index IF NOT EXISTS FOR (b:BudgetTier) ON (b.name);

// IMPORT DANYCH JSON - KARTY

CALL apoc.periodic.iterate(
  "CALL apoc.load.json('file:///all_cards.json') YIELD value RETURN value",
  "UNWIND keys(value) AS cardName
   WITH value[cardName] AS cardData
   MERGE (c:Card {name: cardData.name})
   ON CREATE SET 
     c.manaCost = cardData.manaCost,
     c.cmc = cardData.convertedManaCost,
     c.text = cardData.text,
     c.uuid = cardData.uuid,
     c.colors = cardData.colors,           
     c.rarity = cardData.rarity
   
   WITH c, cardData
   UNWIND cardData.types AS typeName
   MERGE (t:CardType {name: typeName})
   MERGE (c)-[:IS_TYPE]->(t)",
  {batchSize: 1000, parallel: true}
);

// IMPORT DANYCH CSV - TALIE

CALL apoc.periodic.iterate(
  "LOAD CSV WITH HEADERS FROM 'file:///tournament_decks.csv' AS row RETURN row",
  "WITH row WHERE row.Card IS NOT NULL AND row.Pilot IS NOT NULL
   
   MATCH (c:Card {name: row.Card})
   
   SET c.priceUsd = toFloat(row.`Price USD`),

   MERGE (p:Pilot {name: row.Pilot})
   MERGE (a:Archetype {name: row.Archetype})
   MERGE (e:Event {name: row.Event})
   
   MERGE (d:Deck {id: row.Pilot + '_' + row.Event + '_' + row.Archetype})
   ON CREATE SET d.date = row.`Date Posted`
   
   MERGE (p)-[:PILOTED]->(d)
   MERGE (d)-[:PLAYED_IN]->(e)
   MERGE (d)-[:IS_ARCHETYPE]->(a)
   
   MERGE (d)-[:CONTAINS {
       quantity: toInteger(row.Quantity), 
       board: row.`Main/Sideboard`
   }]->(c)",
  {batchSize: 2000, parallel: false}
);

// LOGIKA BIZNESOWA

// Kolory kart
MATCH (c:Card)
WHERE c.colors IS NOT NULL
UNWIND c.colors AS colorCode
WITH c, colorCode,
     CASE colorCode
       WHEN 'W' THEN 'White'
       WHEN 'U' THEN 'Blue'
       WHEN 'B' THEN 'Black'
       WHEN 'R' THEN 'Red'
       WHEN 'G' THEN 'Green'
       ELSE 'Other'
     END AS colorName

MERGE (col:Color {code: colorCode})
ON CREATE SET col.name = colorName
MERGE (c)-[:HAS_COLOR]->(col);

// Rzadkość
MATCH (c:Card) WHERE c.rarity IS NOT NULL
MERGE (r:Rarity {name: c.rarity})
MERGE (c)-[:HAS_RARITY]->(r);

CALL apoc.periodic.iterate(
  "MATCH (c:Card) RETURN c",
  "REMOVE c.colors, c.rarity",
  {batchSize: 5000}
);

// Legalność
CALL apoc.periodic.iterate(
  "CALL apoc.load.json('file:///all_cards.json') YIELD value RETURN value",
  
  "UNWIND keys(value) AS cardName
   WITH value[cardName] AS cardData
   WHERE cardData.legalities IS NOT NULL
   
   MATCH (c:Card {name: cardData.name})
   UNWIND keys(cardData.legalities) AS formatName
   WITH c, formatName, cardData.legalities[formatName] AS legalityStatus
   
   MERGE (f:Format {name: formatName})
   
   MERGE (c)-[r:HAS_STATUS]->(f)
   SET r.status = legalityStatus",
  {batchSize: 1000, parallel: true} 
);

// ZAAWANSOWANA ANALITYKA

// Klasyfikacja Budżetowa 
MATCH (d:Deck)-[r:CONTAINS]->(c:Card)
WITH d, sum(coalesce(c.priceUsd, 0) * r.quantity) AS deckValue
WITH d, deckValue,
     CASE 
       WHEN deckValue < 50 THEN 'Low Budget'
       WHEN deckValue < 300 THEN 'Mid Budget'
       ELSE 'High Budget'
     END AS tierName
MERGE (b:BudgetTier {name: tierName})
MERGE (d)-[r_bud:BELONGS_TO_BUDGET]->(b)
SET r_bud.estimatedPrice = deckValue;

// Style gry Archetypów
MATCH (a:Archetype)
WITH a, CASE 
    WHEN toLower(a.name) CONTAINS 'aggro' OR toLower(a.name) CONTAINS 'red' THEN 'Aggro'
    WHEN toLower(a.name) CONTAINS 'control' THEN 'Control'
    WHEN toLower(a.name) CONTAINS 'midrange' THEN 'Midrange'
    ELSE 'Combo/Other'
END AS style
MERGE (ps:PlayStyle {name: style})
MERGE (a)-[:HAS_PLAYSTYLE]->(ps);

// Mechaniki 
UNWIND ["Deathtouch", "Defender", "Double Strike", "First Strike", "Flash", "Flying", "Haste", "Hexproof", "Indestructible", "Lifelink", "Protection", "Reach", "Shroud", "Trample", "Vigilance", "Ward", "Cycling", "Kicker", "Flashback", "Morph", "Offering", "Convoke", "Dredge", "Transmute", "Poisonous", "Cascade", "Undying", "Miracle", "Menace", "Crew", "Toxic", "Offspring"] AS mechName
MERGE (m:Mechanic {name: mechName})
WITH m
MATCH (c:Card) WHERE c.text CONTAINS m.name
MERGE (c)-[:HAS_MECHANIC]->(m);

// Format Staples 

MATCH (t:Tag {name: 'Format Staple'}) DETACH DELETE t;

MATCH (d:Deck) WITH count(d) AS totalDecks
MATCH (c:Card)<-[:CONTAINS]-(d:Deck)
WHERE NOT (c)-[:IS_TYPE]->(:CardType {name: 'Land'})
WITH c.name AS uniqueName, count(DISTINCT d) AS cardUsage, totalDecks
WHERE (toFloat(cardUsage) / totalDecks) >= 0.30
MERGE (t:Tag {name: 'Format Staple'})
WITH uniqueName, t
MATCH (targetCard:Card {name: uniqueName})
MERGE (targetCard)-[:HAS_TAG]->(t);

// DANE PRZESTRZENNE I PROCEDURY

// Symulacja Geograficzna
UNWIND [
	{name: "Warsaw", lat: 52.2297, lon: 21.0122},
	{name: "Berlin", lat: 52.5200, lon: 13.4050},
	{name: "Paris", lat: 48.8566, lon: 2.3522},
	{name: "London", lat: 51.5074, lon: -0.1278},
	{name: "Prague", lat: 50.0755, lon: 14.4378},
	{name: "Madrid", lat: 40.4168, lon: -3.7038},
	{name: "Rome", lat: 41.9028, lon: 12.4964},
	{name: "Amsterdam", lat: 52.3676, lon: 4.9041}
] AS city
MERGE (v:Venue {name: city.name})
SET v.location = point({latitude: city.lat, longitude: city.lon});
MATCH (e:Event)
WITH e
MATCH (v:Venue)
WITH e, v, rand() AS r
ORDER BY r
WITH e, head(collect(v)) AS randomVenue
MERGE (e)-[:HELD_AT]->(randomVenue);

CREATE POINT INDEX venue_location_index IF NOT EXISTS
FOR (v:Venue) ON (v.location);

// Procedura "Stored Query"
CREATE (proc:SystemProcedure {
name: 'recommendBudgetStaples',
statement: "
	MATCH (c:Card)-[:HAS_COLOR]->(:Color {name: $color})
	WHERE c.priceUsd <= $maxPrice
	MATCH (c)<-[:CONTAINS]-(d:Deck)
	WITH c, count(d) AS popularity
	ORDER BY popularity DESC LIMIT 5
	RETURN c.name AS Card, c.priceUsd AS Price, popularity AS Usage
	"
});

// GDS Similarity

// Budowa grafu podobieństwa talii
CALL gds.graph.project(
    'deck_similarity_graph',
    ['Deck', 'Card'],
    { CONTAINS: {orientation: 'UNDIRECTED'} }
);

CALL gds.nodeSimilarity.write('deck_similarity_graph', {
    writeRelationshipType: 'SIMILAR_TO',
    writeProperty: 'jaccardScore',
    topK: 10,
    similarityCutoff: 0.35
});

CALL gds.graph.drop('deck_similarity_graph');