import io
import csv
import yaml

def parse_csv_metrics(file_bytes):
    content = file_bytes
    reader = csv.DictReader(io.StringIO(content))
    return list(reader)

def parse_yaml_config(file_bytes):
    return yaml.safe_load(file_bytes)
