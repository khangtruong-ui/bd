#!/usr/bin/env python3
import pandas as pd
import kagglehub
from kagglehub import KaggleDatasetAdapter
from sqlalchemy import create_engine
import time
import glob

print("Waiting for PostgreSQL to start...")
time.sleep(5)   # wait for db init

DATABASE_URL = "postgresql://khang:khang@localhost:5432/trafficdb"

for ds_name in glob.glob(os.path.join('.', "*.csv")):
    print("Downloading dataset...")
    df = kagglehub.load_dataset(
        KaggleDatasetAdapter.PANDAS,
        "thanhnguyen2612/traffic-flow-data-in-ho-chi-minh-city-viet-nam",
        ds_name   # <-- ensure CSV filename
    )
    
    print("Downloaded dataset with shape:", df.shape)
    print("Uploading to database...")
    
    engine = create_engine(DATABASE_URL)
    
    df.to_sql("traffic_data", engine, if_exists="replace", index=False)
    
    print("Upload complete!")
