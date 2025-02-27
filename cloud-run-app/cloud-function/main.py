import os
import json
import base64
import psycopg2

# Cloud SQL Connection Details
DB_USER = os.getenv("DB_USER", "myuser")
DB_PASSWORD = os.getenv("DB_PASSWORD", "mypassword")
DB_NAME = os.getenv("DB_NAME", "images")
DB_HOST = os.getenv("DB_HOST", "35.238.77.207")  # Replace with your Cloud SQL IP if needed

def getconn():
    """Creates a direct database connection using Public IP"""
    try:
        print(f"Connecting to Cloud SQL at {DB_HOST}...")
        return psycopg2.connect(
            dbname=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD,
            host=DB_HOST
        )
    except Exception as e:
        print(f"Database connection error: {e}")
        return None

def storage_event_handler(event, context):
    """Triggered when a file is uploaded to Cloud Storage via Pub/Sub."""
    print(f"Received event: {json.dumps(event, indent=2)}")

    try:
        # Decode the Pub/Sub message
        if "data" in event:
            decoded_data = base64.b64decode(event["data"]).decode("utf-8")
            event_data = json.loads(decoded_data)
        else:
            print("Error: Missing 'data' field in event.")
            return
        
        print(f"Decoded event data: {json.dumps(event_data, indent=2)}")

        file_name = event_data.get("name")
        bucket_name = event_data.get("bucket")

        if not file_name or not bucket_name:
            print(f"Error: Missing required fields: name={file_name}, bucket={bucket_name}")
            return

        image_url = f"https://storage.googleapis.com/{bucket_name}/{file_name}"
        print(f"New file detected: {file_name}, URL: {image_url}")

        # Insert into database
        conn = getconn()
        if conn:
            try:
                cursor = conn.cursor()
                cursor.execute(
                    "INSERT INTO images (filename, url) VALUES (%s, %s) "
                    "ON CONFLICT (filename) DO NOTHING",
                    (file_name, image_url)
                )
                conn.commit()
                cursor.close()
                conn.close()
                print(f"Successfully inserted {file_name} into database.")
            except Exception as e:
                print(f"Database insertion error: {e}")
    except Exception as e:
        print(f"Error processing event: {e}")
