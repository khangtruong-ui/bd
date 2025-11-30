# load_data.py

import time
import pandas as pd
import kagglehub
from kagglehub import KaggleDatasetAdapter
from sqlalchemy import create_engine

print("Waiting for MySQL to start...")
time.sleep(10)  # give MySQL a few seconds on first run

# === Download dataset ===
file_path = "train.csv"

df = kagglehub.load_dataset(
    KaggleDatasetAdapter.PANDAS,
    "thanhnguyen2612/traffic-flow-data-in-ho-chi-minh-city-viet-nam",
    file_path
)

print("Loaded rows:", len(df))
print(df.head())

# === Prepare MySQL connection ===
engine = create_engine("mysql+pymysql://root:rootpass@localhost/trafficdb")

# Automatically generate schema & load data
df.to_sql("traffic", engine, if_exists="replace", index=False)

print("Inserted all rows into MySQL using pandas.to_sql()")
