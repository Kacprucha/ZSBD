import pandas as pd
from pymongo import MongoClient
import json
from collections import defaultdict

MONGO_URI = "mongodb://root:root_password@localhost:27017/"
client = MongoClient(MONGO_URI)
db = client['steam_games_db'] 

def import_data():
    print("Importing data...")

    def import_lookup_collection(filename, collection_name, id_col, name_col):
        print(f"\tImporting to collection: {collection_name}...")
        try:
            df = pd.read_csv(filename)
            df.dropna(subset=[id_col, name_col], inplace=True)
        except FileNotFoundError:
            print(f"Error: {filename} not existing")
            return None
        
        items_to_insert = [{'name': row[name_col]} for _, row in df.iterrows()]
        if not items_to_insert:
            return {}
            
        result = db[collection_name].insert_many(items_to_insert, ordered=False)
        
        old_ids = df[id_col].tolist()
        new_ids = result.inserted_ids
        id_map = dict(zip(old_ids, new_ids))
        print(f"\tImported {len(id_map)} documents to '{collection_name}'\n")
        return id_map

    dev_id_map = import_lookup_collection('developers.csv', 'developers', 'id', 'name')
    pub_id_map = import_lookup_collection('publishers.csv', 'publishers', 'id', 'name')
    genre_id_map = import_lookup_collection('genres.csv', 'genres', 'id', 'name')
    cat_id_map = import_lookup_collection('categories.csv', 'categories', 'id', 'name')
    
    def process_junction_table(filename, app_col, link_col):
        print(f"Importing many to many relations: {filename}...")
        try:
            df = pd.read_csv(filename)
        except FileNotFoundError:
            print(f"Error: {filename} not existing")
            return None
        
        links = defaultdict(list)
        for _, row in df.iterrows():
            links[row[app_col]].append(row[link_col])
        return links

    app_dev_links = process_junction_table('application_developers.csv', 'appid', 'developer_id')
    app_pub_links = process_junction_table('application_publishers.csv', 'appid', 'publisher_id')
    app_genre_links = process_junction_table('application_genres.csv', 'appid', 'genre_id')
    app_cat_links = process_junction_table('application_categories.csv', 'appid', 'category_id')

    print("Importing from applications.csv in packets...")
    try:
        chunk_iter = pd.read_csv('applications.csv', low_memory=False, chunksize=5000)
        total_imported = 0

        for chunk in chunk_iter:
            chunk.dropna(subset=['appid', 'name'], inplace=True)
            games_to_insert = []
            
            for _, row in chunk.iterrows():
                appid = int(row['appid'])

                def parse_json_field(field_value):
                    if pd.isna(field_value): return None
                    try: return json.loads(field_value)
                    except (json.JSONDecodeError, TypeError): return None

                release_date_obj = pd.to_datetime(row.get('release_date'), errors='coerce')
                
                dev_ids = [dev_id_map.get(dev_id) for dev_id in app_dev_links.get(appid, []) if dev_id_map.get(dev_id)]
                pub_ids = [pub_id_map.get(pub_id) for pub_id in app_pub_links.get(appid, []) if pub_id_map.get(pub_id)]
                genre_ids = [genre_id_map.get(genre_id) for genre_id in app_genre_links.get(appid, []) if genre_id_map.get(genre_id)]
                cat_ids = [cat_id_map.get(cat_id) for cat_id in app_cat_links.get(appid, []) if cat_id_map.get(cat_id)]

                languages = []
                if pd.notna(row.get('supported_languages')):
                    languages = [lang.strip() for lang in row.get('supported_languages').split(',')]

                game_doc = {
                    '_id': appid,
                    'name': row.get('name'),
                    'type': row.get('type'),
                    'is_free': row.get('is_free'),
                    'release_date': None if pd.isna(release_date_obj) else release_date_obj,
                    'required_age': row.get('required_age'),
                    'description': row.get('short_description'),
                    'supported_languages': languages,
                    'achievement_count': row.get('mat_achievement_count'),
                    
                    'media': {
                        'header_image': row.get('header_image'),
                        'background': row.get('background'),
                    },

                    'reception': {
                        'metacritic_score': row.get('metacritic_score'),
                        'recommendations_total': row.get('recommendations_total')
                    },
                    
                    'price': {
                        'initial': row.get('mat_initial_price'),
                        'final': row.get('mat_final_price'),
                        'discount_percent': row.get('mat_discount_percent'),
                        'currency': row.get('mat_currency')
                    },
                    
                    'platforms': {
                        'windows': row.get('mat_supports_windows'),
                        'mac': row.get('mat_supports_mac'),
                        'linux': row.get('mat_supports_linux')
                    },

                    'requirements': {
                        'pc': {
                            'minimum': {
                                'os': row.get('mat_pc_os_min'),
                                'processor': row.get('mat_pc_processor_min'),
                                'memory': row.get('mat_pc_memory_min'),
                                'graphics': row.get('mat_pc_graphics_min'),
                            },
                            'recommended': {
                                'os': row.get('mat_pc_os_rec'),
                                'processor': row.get('mat_pc_processor_rec'),
                                'memory': row.get('mat_pc_memory_rec'),
                                'graphics': row.get('mat_pc_graphics_rec'),
                            }
                        }
                    },
                    
                    'developer_ids': dev_ids,
                    'publisher_ids': pub_ids,
                    'genre_ids': genre_ids,
                    'category_ids': cat_ids
                }
                games_to_insert.append(game_doc)

            if games_to_insert:
                db.games.insert_many(games_to_insert, ordered=False)
                total_imported += len(games_to_insert)
                print(f"\tImported part of csv, in total: {total_imported} documents")
        
        print("\tImporting to 'games' done")
    except FileNotFoundError as e:
        print(f"Error: applications.csv not existing")
        return
    
    print("Importing from reviews.csv in packets...")
    try:
        review_iter = pd.read_csv('reviews.csv', chunksize=10000)
        valid_game_ids = set(db.games.find({}, {'_id': 1}).distinct('_id'))
        total_reviews = 0

        for chunk in review_iter:
            chunk.dropna(subset=['recommendationid', 'appid'], inplace=True)
            reviews_to_insert = []

            for _, row in chunk.iterrows():
                if row['appid'] in valid_game_ids:
                    created_ts = pd.to_datetime(row.get('timestamp_created'), unit='s', errors='coerce')
                    updated_ts = pd.to_datetime(row.get('timestamp_updated'), unit='s', errors='coerce')
                    last_played_ts = pd.to_datetime(row.get('author_last_played'), unit='s', errors='coerce')

                    review_doc = {
                        '_id': row['recommendationid'],
                        'appid': int(row['appid']),
                        'language': row.get('language'),
                        'text': row.get('review_text'),
                        'is_positive': row.get('voted_up'),
                        
                        'author': {
                            'steamid': row.get('author_steamid'),
                            'num_games_owned': row.get('author_num_games_owned'),
                            'num_reviews': row.get('author_num_reviews'),
                            'playtime_forever': row.get('author_playtime_forever'),
                            'playtime_last_two_weeks': row.get('author_playtime_last_two_weeks'),
                            'playtime_at_review': row.get('author_playtime_at_review'),
                            'last_played': None if pd.isna(last_played_ts) else last_played_ts
                        },
                        
                        'votes': {
                            'up': row.get('votes_up'),
                            'funny': row.get('votes_funny'),
                            'weighted_score': row.get('weighted_vote_score'),
                            'comment_count': row.get('comment_count')
                        },

                        'context': {
                            'steam_purchase': row.get('steam_purchase'),
                            'received_for_free': row.get('received_for_free'),
                            'written_during_early_access': row.get('written_during_early_access')
                        },

                        'timestamps': {
                            'created': None if pd.isna(created_ts) else created_ts,
                            'updated': None if pd.isna(updated_ts) else updated_ts
                        }
                    }
                    reviews_to_insert.append(review_doc)

            if reviews_to_insert:
                db.reviews.insert_many(reviews_to_insert, ordered=False)
                total_reviews += len(reviews_to_insert)
                print(f"\tImported part of csv, in total: {total_reviews} documents.")

        print("Importing to 'reviews' done")
    except FileNotFoundError:
        print(f"Error: reviews.csv not existing")
        return

    print("\nImporting finished succesfuly!")
    client.close()

if __name__ == '__main__':
    import_data()