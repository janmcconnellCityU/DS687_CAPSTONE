# -----------------------------------------------------------
# THIS NEEDS TO BE RUN ONLY ONCE TO CREATE THE db FOR SQLite
# -----------------------------------------------------------

import sqlite3
from pathlib import Path
import pandas as pd

# Resolve project paths
# This file lives in:  DS687_CAPSTONE/sql/00_load_imdb_data.py
# BASE_DIR           = DS687_CAPSTONE
BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "data"
DB_PATH = BASE_DIR / "imdb_data.db"

print(f"Using database at: {DB_PATH}")
print(f"Reading TSVs from: {DATA_DIR}")

# Connect to the existing database (will create it if it does not exist)
conn = sqlite3.connect(DB_PATH)

# Map TSV filenames to SQLite table names
files_to_tables = {
    "name.basics.tsv": "name_basics",
    "title.basics.tsv": "title_basics",
    "title.akas.tsv": "title_akas",
    "title.crew.tsv": "title_crew",
    "title.episode.tsv": "title_episode",
    "title.principals.tsv": "title_principals",
    "title.ratings.tsv": "title_ratings",
}

for fname, table in files_to_tables.items():
    tsv_path = DATA_DIR / fname
    print(f"Loading {fname} into table {table} ...")

    # Read TSV, treat \N as NULL
    df = pd.read_csv(
        tsv_path,
        sep="\t",
        na_values="\\N",
        low_memory=False,
    )

    # Write DataFrame to SQLite
    df.to_sql(table, conn, if_exists="replace", index=False)
    print(f"  -> {len(df):,} rows written to {table}")

conn.close()
print("All tables loaded successfully.")