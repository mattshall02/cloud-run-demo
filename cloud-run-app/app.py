import os
import psycopg2
from flask import Flask, redirect, url_for, session, request
from authlib.integrations.flask_client import OAuth

app = Flask(__name__)
app.secret_key = os.getenv("SECRET_KEY", "random_secret")

# Google OAuth config
oauth = OAuth(app)
oauth.register(
    name='google',
    client_id=os.getenv("GOOGLE_CLIENT_ID"),
    client_secret=os.getenv("GOOGLE_CLIENT_SECRET"),
    access_token_url='https://accounts.google.com/o/oauth2/token',
    access_token_params=None,
    authorize_url='https://accounts.google.com/o/oauth2/auth',
    authorize_params={
        'scope': 'openid email profile',
        'prompt': 'consent'
    },
    api_base_url='https://www.googleapis.com/oauth2/v1/'
)

DB_HOST = os.getenv("DB_HOST", "127.0.0.1")
DB_USER = os.getenv("DB_USER", "myuser")
DB_PASSWORD = os.getenv("DB_PASSWORD", "mypassword")
DB_NAME = os.getenv("DB_NAME", "images")

def get_db_conn():
    return psycopg2.connect(
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
        host=DB_HOST
    )

@app.route("/login")
def login():
    # Force https scheme
    redirect_uri = url_for('auth_callback', _external=True, _scheme='https')
    return oauth.google.authorize_redirect(redirect_uri)

@app.route("/callback")
def auth_callback():
    """
    Google OAuth callback. 
    """
    token = oauth.google.authorize_access_token()  # Exchange code for token
    user_info = oauth.google.get('userinfo').json()  # Grab user profile info
    # e.g. user_info = {"email": "...", "picture": "...", ...}

    # Store user_info in the session
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

# For brevity, let's assume you already have /image, /upload, etc.

@app.route("/upload", methods=["GET", "POST"])
def upload_photo():
    user = session.get('user')
    if not user:
        return "You must be logged in to upload.", 403

    if request.method == "POST":
        # 1) Handle file upload to GCS (like before)
        # 2) Insert into DB, but also store uploader_email

        uploaded_file = request.files.get("file")
        if not uploaded_file:
            return "No file uploaded", 400

        # Example GCS upload (not repeated fully):
        # public_url = upload_to_gcs(uploaded_file, "unique_filename.jpg")

        # Insert DB record with user['email']
        try:
            conn = get_db_conn()
            cursor = conn.cursor()
            cursor.execute(
                "INSERT INTO images (filename, url, uploader_email) VALUES (%s, %s, %s)",
                ("unique_filename.jpg", "https://...", user['email'])
            )
            conn.commit()
            cursor.close()
            conn.close()
        except Exception as e:
            return f"DB error: {e}", 500

        return redirect(url_for("random_image"))
    else:
        return """
        <h2>Upload a Photo (Only logged-in users)</h2>
        <form method="post" enctype="multipart/form-data">
            <input type="file" name="file"/>
            <input type="submit" value="Upload"/>
        </form>
        <p><a href="/">Home</a></p>
        """

@app.route("/image")
def random_image():
    # same logic as before, but you can now also retrieve 'uploader_email' if you want
    # ...
    pass

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
