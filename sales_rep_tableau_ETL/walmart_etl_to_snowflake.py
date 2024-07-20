import os
from kaggle.api.kaggle_api_extended import KaggleApi
import pandas as pd
import io
import snowflake.connector
from sqlalchemy import create_engine
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

KAGGLE_USERNAME = os.getenv('KAGGLE_USERNAME')
KAGGLE_KEY = os.getenv('KAGGLE_KEY')
SNOWFLAKE_USER = os.getenv('SNOWFLAKE_USER')
SNOWFLAKE_PASSWORD = os.getenv('SNOWFLAKE_PASSWORD')
SNOWFLAKE_ACCOUNT = os.getenv('SNOWFLAKE_ACCOUNT')
SNOWFLAKE_WAREHOUSE = os.getenv('SNOWFLAKE_WAREHOUSE')
SNOWFLAKE_DATABASE = os.getenv('SNOWFLAKE_DATABASE')
SNOWFLAKE_SCHEMA = os.getenv('SNOWFLAKE_SCHEMA')

# Authenticate Kaggle API
api = KaggleApi()
api.authenticate()

# Download dataset files from Kaggle
dataset = 'prajjwal1/retail-analysis-walmart-data'
sales_data = api.dataset_download_file(dataset, 'sales_data.csv')
sales_df = pd.read_csv(io.BytesIO(sales_data.content))

store_data = api.dataset_download_file(dataset, 'stores.csv')
store_df = pd.read_csv(io.BytesIO(store_data.content))

features_data = api.dataset_download_file(dataset, 'features.csv')
features_df = pd.read_csv(io.BytesIO(features_data.content))

# Data Cleaning and Transformation
sales_df.fillna(0, inplace=True)
sales_df['Date'] = pd.to_datetime(sales_df['Date'])
sales_df['Weekly_Sales_Growth'] = sales_df.groupby('Store')['Weekly_Sales'].pct_change()
merged_df = pd.merge(sales_df, store_df, on='Store')
merged_df = pd.merge(merged_df, features_df, on=['Store', 'Date'])

# Connect to Snowflake
conn = snowflake.connector.connect(
    user=SNOWFLAKE_USER,
    password=SNOWFLAKE_PASSWORD,
    account=SNOWFLAKE_ACCOUNT,
    warehouse=SNOWFLAKE_WAREHOUSE,
    database=SNOWFLAKE_DATABASE,
    schema=SNOWFLAKE_SCHEMA
)

# Create table in Snowflake
create_table_query = """
CREATE OR REPLACE TABLE walmart_sales (
    Store INT,
    Date DATE,
    Weekly_Sales FLOAT,
    Weekly_Sales_Growth FLOAT,
    Temperature FLOAT,
    Fuel_Price FLOAT,
    CPI FLOAT,
    Unemployment FLOAT,
    IsHoliday BOOLEAN,
    Type STRING,
    Size INT
);
"""
conn.cursor().execute(create_table_query)

# Load data into Snowflake
from snowflake.connector.pandas_tools import write_pandas
write_pandas(conn, merged_df, 'walmart_sales')
