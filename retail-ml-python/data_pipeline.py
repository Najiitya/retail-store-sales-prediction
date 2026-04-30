import requests
import pandas as pd

# The URL of your running Node.js backend (Make sure your Node server is running!)
NODE_API_URL = "http://localhost:5000/api/sales"

def fetch_sales_data():
    try:
        print("Fetching data from Node.js API")
        response = requests.get(NODE_API_URL)
        response.raise_for_status()

        data = response.json()
        df = pd.DataFrame(data)

        if df.empty:
            print("Warning: The database is currently empty.")
            return df
        
        print(f"Successfully loaded {len(df)} sales records into pandas")

        #cleanuo data for machine learning
        df["createdAt"] = pd.to_datetime(df["createdAt"])

        return df
    
    except Exception as e:
        print(f"Error fetching data {e}")
        return None
    
if __name__ == "__main__":
    df = fetch_sales_data()
    if df is not None and not df.empty:
        print(df.head())