from dotenv import load_dotenv
load_dotenv()

import os
import pg8000
from google.cloud.sql.connector import Connector
from flask import Flask, redirect, url_for, session, request
from authlib.integrations.flask_client import OAuth
from google.cloud import storage
from functools import wraps
from werkzeug.utils import secure_filename
import uuid
from contextlib import contextmanager

app = Flask(__name__)
app.secret_key = os.getenv("SECRET_KEY", "random_secret")

# Google OAuth config
oauth = OAuth(app)
oauth.register(
    name='google',
    client_id=os.getenv("GOOGLE_CLIENT_ID"),
    client_secret=os.getenv("GOOGLE_CLIENT_SECRET"),
    server_metadata_url="https://accounts.google.com/.well-known/openid-configuration",
    client_kwargs={
        "scope": "openid email profile"
    }
)

# Database credentials
DB_USER = os.getenv("DB_USER", "myuser")
DB_PASSWORD = os.getenv("DB_PASSWORD", "password")
DB_NAME = os.getenv("DB_NAME", "images")
DB_INSTANCE_CONNECTION_NAME = os.getenv("DB_INSTANCE_CONNECTION_NAME", "cloud-run-demo-452116:us-central1:image-db")

# Initialize the connector once
connector = Connector()

@contextmanager
def get_db_conn():
    conn = connector.connect(
        DB_INSTANCE_CONNECTION_NAME,
        "pg8000",
        user=DB_USER,
        password=DB_PASSWORD,
        db=DB_NAME
    )
    try:
        yield conn
        conn.commit()
    except Exception as e:
        conn.rollback()
        raise
    finally:
        conn.close()

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user' not in session:
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function

def generate_unique_filename(filename):
    ext = os.path.splitext(filename)[1]
    return f"{uuid.uuid4()}{ext}"

@app.route("/login")
def login():
    redirect_uri = url_for('auth_callback', _external=True, _scheme='https')
    return oauth.google.authorize_redirect(redirect_uri)

@app.route("/callback")
def auth_callback():
    token = oauth.google.authorize_access_token()
    user_info = oauth.google.userinfo()
    session['user'] = user_info
    return redirect(url_for('index'))

@app.route("/logout")
def logout():
    session.pop('user', None)
    return redirect(url_for('index'))

@app.route("/")
def index():
    user = session.get('user')
    if user:
        return f"<h1>Welcome {user['email']}</h1><p><a href='/upload'>Upload Photo</a> | <a href='/image'>Random Image</a> | <a href='/logout'>Logout</a></p>"
    else:
        return "<h1>Welcome Guest</h1><p><a href='/login'>Login with Google</a> | <a href='/image'>Random Image</a></p>"

@app.route("/upload", methods=["GET", "POST"])
@login_required
def upload_photo():
    if request.method == "POST":
        uploaded_file = request.files.get("file")
        if not uploaded_file:
            return "No file uploaded", 400

        filename = secure_filename(uploaded_file.filename)
        unique_filename = generate_unique_filename(filename)

        # TODO: Implement GCS upload logic here
        # public_url = upload_to_gcs(uploaded_file, unique_filename)
        public_url = "https://example.com/placeholder"  # Placeholder URL

        try:
            with get_db_conn() as conn:
                with conn.cursor() as cursor:
                    cursor.execute(
                        "INSERT INTO images (filename, url, uploader_email) VALUES (%s, %s, %s)",
                        (unique_filename, public_url, session['user']['email'])
                    )
            return redirect(url_for("show_photo", filename=unique_filename))
        except Exception as e:
            return f"DB error: {e}", 500
    else:
        return """
        <h2>Upload a Photo (Only logged-in users)</h2>
        <form method="post" enctype="multipart/form-data">
            <input type="file" name="file" accept="image/*" />
            <input type="submit" value="Upload"/>
        </form>
        <p><a href="/">Home</a></p>
        """

@app.route("/photo/<filename>")
def show_photo(filename):
    try:
        with get_db_conn() as conn:
            with conn.cursor() as cursor:
                cursor.execute(
                    "SELECT url, uploader_email FROM images WHERE filename = %s",
                    (filename,)
                )
                record = cursor.fetchone()

        if record:
            url, uploader_email = record
            return f"""
            <h2>Photo Uploaded by {uploader_email}</h2>
            <img src="{url}" style="max-width:80%; height:auto;" />
            <p><a href="/">Home</a></p>
            """
        else:
            return "Photo not found", 404
    except Exception as e:
        return f"DB error: {e}", 500

@app.route("/image")
def random_image():
    try:
        with get_db_conn() as conn:
            with conn.cursor() as cursor:
                cursor.execute("SELECT url FROM images ORDER BY RANDOM() LIMIT 1;")
                record = cursor.fetchone()

        if record:
            image_url = record[0]
            return f'<img src="{image_url}" style="max-width:80%; height:auto;">'
        else:
            return "No images found."
    except Exception as e:
        return f"DB error: {e}", 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
