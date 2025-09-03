import pandas as pd

from Helper import *

from pathlib import Path
import json
import os

def dump_json(heats):
    # Convert the heats object to a dictionary
    heats_dict = {"heats": [heats.__dict__]}    
    # Function to recursively convert nested objects to dictionaries
    def convert_to_dict(obj):
        if isinstance(obj, list):
            return [convert_to_dict(item) for item in obj]
        elif hasattr(obj, "__dict__"):
            result = {}
            for key, value in obj.__dict__.items():
                result[key] = convert_to_dict(value)
            return result
        else:
            return obj
    # Convert the heats object to a dictionary
    heats_dict = {"heats": [convert_to_dict(heats)]}
    # Serialize the dictionary to a JSON string
    heats_json = json.dumps(heats_dict, indent=4)
    return heats_json
def read_json(file_path):
    with open(file_path, 'r') as file:
        data = json.load(file)
    return data


def save_json_to_file(heats_json, file_path):
    with open(file_path, 'w') as file:
        file.write(heats_json)
def save_dataframe_to_csv(df, file_path):
    df.to_csv(file_path, index=False)
def save_dataframe_to_excel(df, file_path):
    df.to_excel(file_path, index=False)
def process_json_file(input_file, json_output_file, csv_output_file, excel_output_file):
    data = read_json(input_file)
    heats = json_to_classes(data)
    heats_json = dump_json(heats[0])  # Assuming we want to dump the first heat for simplicity
    save_json_to_file(heats_json, json_output_file)
    df = json_to_dataframe(data)
    save_dataframe_to_csv(df, csv_output_file)
    save_dataframe_to_excel(df, excel_output_file)


 
if __name__ == "__main__":
    df_Performance = readJsonfile(folder_path='C:\Drive_D\Stelco-BOF\Statics-Python\JsonTransferFromStelco\static\PerformanceValue')
    df_CyclicTrend = readJsonfile(folder_path='C:\Drive_D\Stelco-BOF\Statics-Python\JsonTransferFromStelco\static\TrendValue')
    df_SteelGrade = readJsonfile(folder_path='C:\Drive_D\Stelco-BOF\Statics-Python\JsonTransferFromStelco\static\SteelGrade')
    heats = json_to_classes(df_Performance,df_CyclicTrend,df_SteelGrade)

    json_data = json.dumps(heats, default=lambda o: o.__dict__, indent=4)

    data = json.loads(json_data)
    
    data = replace_nan_with_none(data)  
    data =remove_null_properties(data)  
    json_data = json.dumps(data,allow_nan=False, default=lambda o: o.__dict__, indent=4)

    json_data =  '{"Heats": ' + json_data + '}'
    now = datetime.now()
    filename_now = now.strftime("%Y-%m-%d_%H-%M-%S")+'.json'
    filepath = Path('C:\Drive_D\Stelco-BOF\Statics-Python\JsonTransferFromStelco\Export') / filename_now
    filepath.parent.mkdir(parents=True, exist_ok=True)
    with open(filepath, 'w',encoding='utf-8') as file:
        file.write(json_data)
 
    

                           

