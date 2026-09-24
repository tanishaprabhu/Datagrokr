import requests
import pandas as pd


API_URL = "https://jsonplaceholder.typicode.com/users"


def fetch_data():
    response = requests.get(API_URL)

    if response.status_code != 200:
        raise Exception("Failed to fetch data")

    return response.json()


def transform_data(data):
    rows = []

    for user in data:
        rows.append({
            "id": user["id"],
            "name": user["name"],
            "email": user["email"],
            "city": user["address"]["city"]
        })

    return pd.DataFrame(rows)


def save_to_csv(df, filename="output.csv"):
    df.to_csv(filename, index=False)


def main():
    print("Starting ETL Pipeline...")

    # Extract
    data = fetch_data()
    print("Data fetched successfully.")

    # Transform
    df = transform_data(data)
    print("Data transformed successfully.")

    # Load
    save_to_csv(df)
    print("Data saved to output.csv")

    print("\nFinal Data:")
    print(df)


if __name__ == "__main__":
    main()