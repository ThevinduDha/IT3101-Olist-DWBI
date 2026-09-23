import pandas as pd
import os
import glob

# Pointing to the new folder you just created
dataset_path = r"C:\OlistDW\raw_data"
all_files = glob.glob(os.path.join(dataset_path, "*.csv"))

for file in all_files:
    file_name = os.path.basename(file)
    print(f"\n--- Profiling {file_name} ---")
    
    try:
        df = pd.read_csv(file)
        print(f"Row Count: {len(df)}")
        print(f"Columns: {len(df.columns)}")
        print(f"Duplicates: {df.duplicated().sum()}")
        
        missing = df.isnull().sum()
        missing = missing[missing > 0]
        if not missing.empty:
            print(f"Missing Values:\n{missing}")
        else:
            print("Missing Values: None")
    except Exception as e:
        print(f"Could not read {file_name}: {e}")