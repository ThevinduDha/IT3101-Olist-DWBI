import pandas as pd
import shutil
import os

raw_dir = r"C:\OlistDW\raw_data"
landing_dir = r"C:\OlistDW\landing"

# 1. Sellers to Pipe-delimited TXT
print("Converting sellers to TXT...")
sellers = pd.read_csv(rf"{raw_dir}\olist_sellers_dataset.csv")
sellers.to_csv(rf"{landing_dir}\sellers\sellers.txt", sep='|', index=False)

# 2. Reviews to JSON
print("Converting reviews to JSON...")
reviews = pd.read_csv(rf"{raw_dir}\olist_order_reviews_dataset.csv")
reviews.to_json(rf"{landing_dir}\reviews\reviews.json", orient='records', lines=True)

# 3. Category Translation to Excel
print("Converting category translation to Excel...")
category = pd.read_csv(rf"{raw_dir}\product_category_name_translation.csv")
category.to_excel(rf"{landing_dir}\reference\category_translation.xlsx", index=False)

# 4. Copy Payments and Geolocation CSVs
print("Copying CSV files...")
shutil.copy(rf"{raw_dir}\olist_order_payments_dataset.csv", rf"{landing_dir}\payments\payments.csv")
shutil.copy(rf"{raw_dir}\olist_geolocation_dataset.csv", rf"{landing_dir}\geolocation\geolocation.csv")

print("Local files successfully prepared and moved to landing zones.")