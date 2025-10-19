import psycopg2
import psycopg2.extras
from faker import Faker
import random
from datetime import datetime, timedelta
import time

# ==============================================================================
# KONFIGURACJA DOSTĘPU DO BAZY DANYCH
# Uzupełnij poniższe dane, aby skrypt mógł połączyć się z Twoją bazą.
# ==============================================================================
DB_CONFIG = {
    "dbname": "twoja_baza",
    "user": "twoj_uzytkownik",
    "password": "twoje_haslo",
    "host": "localhost",  # lub adres IP serwera bazy danych
    "port": "5432"
}

# Inicjalizacja generatora danych
fake = Faker()

# Liczba rekordów do wygenerowania
NUM_CHARACTERS = 10000
NUM_QUEST_LOGS = 500000
BATCH_SIZE = 1000  # Liczba rekordów wstawianych jednorazowo

def get_existing_data(cursor):
    """Pobiera z bazy danych istniejące klucze obce potrzebne do generowania."""
    print("Pobieranie istniejących danych (rasy, klasy, statusy, questy)...")
    
    # Pobieranie ras
    cursor.execute("SELECT Name FROM game_data.Race;")
    races = [row[0] for row in cursor.fetchall()]
    
    # Pobieranie klas
    cursor.execute("SELECT Name FROM game_data.Class;")
    classes = [row[0] for row in cursor.fetchall()]
    
    # Pobieranie statusów kont
    cursor.execute("SELECT StatusID FROM game_data.AccountStatus;")
    account_statuses = [row[0] for row in cursor.fetchall()]
    
    # Pobieranie ID questów
    cursor.execute("SELECT QuestID FROM game_data.Quest;")
    quest_ids = [row[0] for row in cursor.fetchall()]

    # Pobieranie ID statusów questów
    cursor.execute("SELECT StatusID FROM game_data.QuestStatus;")
    quest_status_ids = [row[0] for row in cursor.fetchall()]
    
    if not all([races, classes, account_statuses, quest_ids, quest_status_ids]):
        raise ValueError("Jedna z tabel słownikowych (Race, Class, AccountStatus, Quest, QuestStatus) jest pusta. Uzupełnij je przed uruchomieniem skryptu.")
        
    print("Dane słownikowe wczytane pomyślnie.")
    return {
        "races": races,
        "classes": classes,
        "account_statuses": account_statuses,
        "quest_ids": quest_ids,
        "quest_status_ids": quest_status_ids
    }

def generate_characters_and_players(num_characters, existing_data):
    """Generuje dane dla tabel Player, Character i tabel łączących."""
    print(f"Przygotowywanie {num_characters} graczy i postaci...")
    players = []
    characters = []
    race_characters = []
    class_characters = []
    
    # Używamy zbioru, aby zapewnić unikalność nazw
    generated_names = set()

    for i in range(num_characters):
        # Generowanie unikalnej nazwy użytkownika/postaci
        while True:
            username = fake.user_name()[:10] # Ograniczenie długości do 10 znaków
            if username not in generated_names:
                generated_names.add(username)
                break
        
        # 1. Dane gracza
        players.append((
            username,
            fake.email()[:20],
            psycopg2.Binary(b'\x12\x34\x56'), # Przykładowy hash
            random.choice(existing_data["account_statuses"])
        ))
        
        # 2. Dane postaci
        characters.append((
            username, # Używamy tej samej nazwy dla postaci
            False, # IsNPC
            random.randint(1, 100), # Level
            random.randint(100, 1000), # MaxHitPoints
            random.randint(50, 500), # MaxMana
            random.randint(0, 10000), # Gold
            random.randint(0, 1000000), # Experience
            username # Player_Userame
        ))
        
        # 3. Przypisanie rasy i klasy
        race_characters.append((random.choice(existing_data["races"]), username))
        class_characters.append((username, random.choice(existing_data["classes"])))

    return players, characters, race_characters, class_characters, list(generated_names)

def generate_quest_logs(num_logs, character_names, existing_data):
    """Generuje dane logów questów."""
    print(f"Przygotowywanie {num_logs} wpisów do dziennika zadań...")
    quest_logs = []

    for _ in range(num_logs):
        character_name = random.choice(character_names)
        quest_id = random.choice(existing_data["quest_ids"])
        status_id = random.choice(existing_data["quest_status_ids"])
        
        start_time = fake.date_time_between(start_date='-2y', end_date='now')
        end_time = None
        
        # Ustaw EndTime tylko jeśli status to 'Completed' lub 'Failed' (załóżmy ID 3 i 4)
        if status_id in [3, 4]:
            end_time = start_time + timedelta(hours=random.randint(1, 72))

        quest_logs.append((
            character_name,
            quest_id,
            status_id,
            random.randint(1, 5), # AtemptNumber
            start_time,
            end_time
        ))
    return quest_logs

def main():
    """Główna funkcja skryptu."""
    conn = None
    try:
        # Połączenie z bazą danych
        print("Łączenie z bazą danych PostgreSQL...")
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        
        # Ustawienie schematu
        cur.execute("SET search_path TO game_data;")
        
        # Pobranie danych słownikowych
        existing_data = get_existing_data(cur)
        
        # --- Krok 1: Generowanie i wstawianie Postaci ---
        start_time = time.time()
        players, characters, race_chars, class_chars, char_names = generate_characters_and_players(NUM_CHARACTERS, existing_data)
        
        print(f"Wstawianie {len(players)} rekordów do tabeli Player...")
        psycopg2.extras.execute_batch(cur, "INSERT INTO Player (Username, Email, Password_hash, AccountStatus_StatusName) VALUES (%s, %s, %s, %s)", players, page_size=BATCH_SIZE)
        
        print(f"Wstawianie {len(characters)} rekordów do tabeli Character...")
        psycopg2.extras.execute_batch(cur, "INSERT INTO Character (Name, IsNPC, Level, MaxHitPoints, MaxMana, Gold, Experience, Player_Userame) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)", characters, page_size=BATCH_SIZE)

        print(f"Wstawianie {len(race_chars)} rekordów do tabeli Race_Character...")
        psycopg2.extras.execute_batch(cur, "INSERT INTO Race_Character (Race_Name, Character_Name) VALUES (%s, %s)", race_chars, page_size=BATCH_SIZE)

        print(f"Wstawianie {len(class_chars)} rekordów do tabeli Character_Class...")
        psycopg2.extras.execute_batch(cur, "INSERT INTO Character_Class (Character_Name, Class_Name) VALUES (%s, %s)", class_chars, page_size=BATCH_SIZE)
        
        conn.commit()
        end_time = time.time()
        print(f"Generowanie postaci zakończone w {end_time - start_time:.2f} sekund.")

        # --- Krok 2: Generowanie i wstawianie Quest Logów ---
        start_time = time.time()
        quest_logs_data = generate_quest_logs(NUM_QUEST_LOGS, char_names, existing_data)
        
        print(f"Wstawianie {len(quest_logs_data)} rekordów do tabeli QuestLog...")
        psycopg2.extras.execute_batch(cur, "INSERT INTO QuestLog (Character_Name, Quest_QuestID, QuestStatus_StatusID, AtemptNumber, StartTime, EndTime) VALUES (%s, %s, %s, %s, %s, %s)", quest_logs_data, page_size=BATCH_SIZE)
        
        conn.commit()
        end_time = time.time()
        print(f"Generowanie logów questów zakończone w {end_time - start_time:.2f} sekund.")

        print("\nSkrypt zakończył działanie pomyślnie!")

    except (Exception, psycopg2.DatabaseError) as error:
        print(f"Wystąpił błąd: {error}")
        if conn:
            conn.rollback() # Wycofanie transakcji w razie błędu
    finally:
        if conn:
            cur.close()
            conn.close()
            print("Połączenie z bazą danych zostało zamknięte.")

if __name__ == "__main__":
    main()