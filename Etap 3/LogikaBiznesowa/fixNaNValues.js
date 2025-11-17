use('steam_games_db');

print("NAPRAWA NaN W BAZIE");

db.runCommand({
  collMod: "games",
  validationLevel: "off"
});

const countNaN = db.games.countDocuments({
  $or: [
    { "price.initial": NaN },
    { "price.final": NaN },
    { "price.discount_percent": NaN },
    { "price.currency": "NaN" },
    { "reception.metacritic_score": NaN },
    { "reception.recommendations_total": NaN }
  ]
});

print(`Znaleziono ${countNaN} dokumentów z wartościami NaN\n`);

print("Naprawa price.initial...");
let result = db.games.updateMany(
  { "price.initial": NaN },
  { $set: { "price.initial": 0 } }
);
print(`  Zaktualizowano: ${result.modifiedCount}`);

print("Naprawa price.final...");
result = db.games.updateMany(
  { "price.final": NaN },
  { $set: { "price.final": 0 } }
);
print(`  Zaktualizowano: ${result.modifiedCount}`);

print("Naprawa price.discount_percent...");
result = db.games.updateMany(
  { "price.discount_percent": NaN },
  { $set: { "price.discount_percent": 0 } }
);
print(`  Zaktualizowano: ${result.modifiedCount}`);

print("Naprawa price.currency...");
result = db.games.updateMany(
  { "price.currency": "NaN" },
  { $set: { "price.currency": "USD" } }
);
print(`  Zaktualizowano: ${result.modifiedCount}`);

print("Naprawa reception.metacritic_score...");
result = db.games.updateMany(
  { "reception.metacritic_score": NaN },
  { $unset: { "reception.metacritic_score": "" } }
);
print(`  Zaktualizowano: ${result.modifiedCount}`);

print("Naprawa reception.recommendations_total...");
result = db.games.updateMany(
  { "reception.recommendations_total": NaN },
  { $set: { "reception.recommendations_total": 0 } }
);
print(`  Zaktualizowano: ${result.modifiedCount}`);

const stillNaN = db.games.countDocuments({
  $or: [
    { "price.initial": NaN },
    { "price.final": NaN },
    { "price.discount_percent": NaN },
    { "price.currency": "NaN" },
    { "reception.metacritic_score": NaN },
    { "reception.recommendations_total": NaN }
  ]
});

print(`\nPozostawionych dokumentów z NaN: ${stillNaN}`);

db.runCommand({
  collMod: "games",
  validationLevel: "strict"
});

print("\n Walidacja włączona");
print("NAPRAWA ZAKOŃCZONA");