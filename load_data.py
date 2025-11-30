import kagglehub
from kagglehub import KaggleDatasetAdapter
import pandas as pd
from sqlalchemy import create_engine
import time

# Give MySQL time
time.sleep(5)

# Load CSV
df = kagglehub.load_dataset(
    KaggleDatasetAdapter.PANDAS,
    "thanhnguyen2612/traffic-flow-data-in-ho-chi-minh-city-viet-nam",
    "train.csv"
)

# Connect to MySQL via UNIX socket
engine = create_engine("mysql+pymysql://root:rootpass@localhost/trafficdb?unix_socket=/tmp/mysql.sock")

df.to_sql("traffic", engine, if_exists="replace", index=False)

print("Preload done!")
