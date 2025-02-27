import os
import uuid
import psycopg2
import time
import logging

from flask import Flask, request, redirect, url_for, render_template_string
from google.cloud import storage

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_USER = os.getenv("DB_USER", "myuser")
DB_PASSWORD = os.getenv("DB_PASSWORD", "mypassword")
DB_NAME = os.getenv("DB_NAME", "images")
GCS_BUCKET_NAME = os.getenv("GCS_BUCKET_NAME", "your-bucket")

def get_db_connection():
    return psycopg2.connect(
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
        host=DB_HOST
    )

def upload_to_gcs(file_stream, filename):
    """Uploads a file to the GCS bucket and returns the public URL."""
    client = storage.Client()
    bucket = client.bucket(GCS_BUCKET_NAME)
    blob = bucket.blob(filename)
    blob.upload_from_file(file_stream, content_type="image/jpeg")

    # Make the object publicly accessible
    blob.make_public()

    return blob.public_url

@app.route("/")
def index():
    return """<h1>Welcome to Cloud Run!</h1>
              <p><a href="/upload">Upload New Image</a></p>
              <p><a href="/image">View Random Image</a></p>"""

@app.route("/image")
def random_image():
    logger.info("Fetching random image from DB")
    url = None
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT url FROM images ORDER BY RANDOM() LIMIT 1;")
        row = cur.fetchone()
        cur.close()
        conn.close()
        if row:
            url = row[0]
    except Exception as e:
        logger.error(f"DB error: {e}")

    if url:
        return f'<img src="{url}" style="max-width: 80%; height:auto;">'
    else:
        return "No images found in the database."

@app.route("/upload", methods=["GET", "POST"])
def upload_image():
    if request.method == "POST":
        if "file" not in request.files:
            return "No file part", 400

        file = request.files["file"]
        if file.filename == "":
            return "No selected file", 400

        # Generate a unique filename (just in case)
        # e.g. <uuid>.jpg
        unique_filename = f"{uuid.uuid4()}.jpg"

        # Upload file to GCS
        try:
            public_url = upload_to_gcs(file, unique_filename)
        except Exception as e:
            logger.error(f"GCS upload error: {e}")
            return "Error uploading to GCS", 500

        # Insert into DB
        try:
            conn = get_db_connection()
            cur = conn.cursor()
            cur.execute(
                "INSERT INTO images (filename, url) VALUES (%s, %s) ON CONFLICT DO NOTHING",
                (unique_filename, public_url)
            )
            conn.commit()
            cur.close()
            conn.close()
        except Exception as e:
            logger.error(f"DB insertion error: {e}")
            return "Error inserting into DB", 500

        # Redirect back to /image or /upload
        return redirect(url_for("random_image"))

    else:
        # Display a simple upload form
        return render_template_string("""
        <h2>Upload an Image</h2>
        <form method="post" enctype="multipart/form-data">
            <p><input type="file" name="file" accept="image/*"></p>
            <p><input type="submit" value="Upload"></p>
        </form>
        <p><a href="/">Back to Home</a></p>
        """)

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))
    app.run(host="0.0.0.0", port=port)
