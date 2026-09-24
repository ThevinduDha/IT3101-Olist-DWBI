import os
import pandas as pd
from sqlalchemy import create_engine

# 1. Update this to the folder containing your Olist CSV files
csv_folder_path = csv_folder_path = r"C:\OlistDW\raw_data"

# 2. Connection string to your olist_oltp database
server = "."
database = "olist_oltp"
connection_string = f"mssql+pyodbc://{server}/{database}?driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=yes"

engine = create_engine(connection_string)

# 3. List of Olist CSV files to load
csv_files = {
    "customers": "olist_customers_dataset.csv",
    "orders": "olist_orders_dataset.csv",
    "order_items": "olist_order_items_dataset.csv",
    "products": "olist_products_dataset.csv",
    "sellers": "olist_sellers_dataset.csv",
    "payments": "olist_order_payments_dataset.csv",
    "reviews": "olist_order_reviews_dataset.csv",
}

# 4. Loop through and load into SQL Server
for table_name, filename in csv_files.items():
  file_path = os.path.join(csv_folder_path, filename)
  if os.path.exists(file_path):
    print(f"Loading {filename} into table [{table_name}]...")
    df = pd.read_csv(file_path)
    # Write to SQL Server (replaces table if it exists)
    df.to_sql(
        table_name,
        con=engine,
        if_exists="replace",
        index=False,
        chunksize=10000,
    )
    print(f"Successfully loaded {table_name}!")
  else:
    print(f"File not found: {filename}")

print("All available Olist tables loaded successfully into olist_oltp!")