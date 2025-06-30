# Use official Python 3.11 base image
FROM python:3.11.13

# Set working directory
WORKDIR /app

# Copy requirements file and install dependencies
COPY requirements.txt .

COPY deps/ ./deps/

RUN pip install --no-index --find-links=./deps/ -r requirements.txt

# Copy the rest of the project files
COPY . .

# Set the command to run the server
CMD ["python", "main.py"]
