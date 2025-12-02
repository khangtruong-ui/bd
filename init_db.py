#!/usr/bin/env python3
import pandas as pd
import kagglehub
from kagglehub import KaggleDatasetAdapter
from sqlalchemy import create_engine
import time
import glob
import os

print("Waiting for PostgreSQL to start...")
time.sleep(5)   # wait for db init

DATABASE_URL = "postgresql://khang:khang@localhost:5432/trafficdb"

for ds_name in glob.glob(os.path.join('.', "*.csv")):
    print("Downloading dataset...")
    df = pd.read_csv(ds_name)
    
    print("Downloaded dataset with shape:", df.shape)
    print("Uploading to database...")
    
    engine = create_engine(DATABASE_URL)
    
    df.to_sql("traffic_data", engine, if_exists="replace", index=False)
    os.remove(ds_name)
    print("Upload complete!")
