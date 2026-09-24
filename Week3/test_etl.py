import pandas as pd
from etl import transform_data, save_to_csv


def test_transform_data():
    data = [
        {
            "id": 1,
            "name": "John",
            "email": "john@test.com",
            "address": {
                "city": "Bangalore"
            }
        }
    ]

    df = transform_data(data)

    assert len(df) == 1
    assert df.iloc[0]["name"] == "John"
    assert df.iloc[0]["email"] == "john@test.com"
    assert df.iloc[0]["city"] == "Bangalore"


def test_save_to_csv(tmp_path):
    df = pd.DataFrame({
        "id": [1],
        "name": ["John"],
        "email": ["john@test.com"],
        "city": ["Bangalore"]
    })

    file_path = tmp_path / "test_output.csv"

    save_to_csv(df, file_path)

    assert file_path.exists()

    result = pd.read_csv(file_path)

    assert result.iloc[0]["name"] == "John"