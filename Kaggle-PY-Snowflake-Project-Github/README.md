# Kaggle to Snowflake Data Transfer Automation

This guide provides instructions for automating the transfer of datasets from Kaggle to Snowflake using Python. It involves streaming datasets directly from Kaggle into a Python script and then uploading them to Snowflake.

My Medium post about this project https://medium.com/@datawithlu/kaggle-dataset-to-snowflake-database-automation-etl-38d85676fe42

## Prerequisites
- Kaggle Account: Sign up or log in at [Kaggle](https://www.kaggle.com/).
- Snowflake Account: Sign up or log in at [Snowflake](https://www.snowflake.com/).
- Python Environment: Ensure Python is installed with necessary libraries.

## Installation

### Install Required Libraries
bash
pip install kaggle snowflake-connector-python pandas

# Configuration

## Kaggle API Credentials
- Obtain your API credentials (username and key) from your Kaggle account settings.
##Environment Variables
- Optionally, set up environment variables for Kaggle and Snowflake credentials.
- insert into cred.json
  
## Kaggle API Setup in Python
import kaggle
kaggle.api.authenticate()

# Data Transfer Process

## Access Kaggle Dataset
- Use Kaggle API to retrieve the dataset's direct download link.


## Data Processing (Optional)
- Process or transform the data as needed.
  
## Connect to Snowflake
- find at snowflake admin database (manual or ChatGTP can help)
- "schema" can be null
- insert into cred.json

## Upload Data to Snowflake
cursor = conn.cursor()
- Example SQL command to upload data
- cursor.execute("SQL_COMMAND")

## Close Connections
cursor.close()
conn.close()

## Important Notes
- Ensure secure handling of all authentication and credentials.
- Be mindful of API rate limits and data constraints on Kaggle and Snowflake.
- Initially test with a smaller dataset to ensure smooth operation.
- For large datasets, consider batch processing or streaming methods for efficiency.
- Modify steps as needed based on specific dataset requirements.

Replace `"KAGGLE_DATASET_URL"`, `"YOUR_USER"`, `"YOUR_PASSWORD"`, and `"YOUR_ACCOUNT"` with actual values or variables containing these values. This guide assumes users have the necessary environment and knowledge to execute Python scripts.

