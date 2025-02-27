gcloud services enable run.googleapis.com     artifactregistry.googleapis.com     cloudbuild.googleapis.com     iam.googleapis.com
gcloud projects list
gcloud config set project cloud-run-demo
gcloud services enable run.googleapis.com     artifactregistry.googleapis.com     cloudbuild.googleapis.com     iam.googleapis.com
gcloud projects list
gcloud config list account
gcloud projects list
gcloud config set project cloud-run-demo-452116
gcloud services enable run.googleapis.com     artifactregistry.googleapis.com     cloudbuild.googleapis.com     iam.googleapis.com
mkdir cloud-run-app && cd cloud-run-app
nano app.py
nano Dockerfile
gcloud auth configure-docker us-central1-docker.pkg.dev
gcloud artifacts repositories create my-repo     --repository-format=docker     --location=us-central1     --description="My Cloud Run Docker Repo"
docker build -t us-central1-docker.pkg.dev/cloud-run-demo-452116/my-repo/cloud-run-app .
docker push us-central1-docker.pkg.dev/cloud-run-demo-452116/my-repo/cloud-run-app
gcloud run deploy cloud-run-app     --image=us-central1-docker.pkg.dev/cloud-run-demo-452116/my-repo/cloud-run-app     --region=us-central1     --platform=managed     --allow-unauthenticated
BUCKET_NAME=cloud-run-demo-452116-images
gcloud storage buckets create $BUCKET_NAME --location=us-central1
BUCKET_NAME="cloud-run-demo-452116-images"
gcloud storage buckets create gs://$BUCKET_NAME --location=us-central1
wget -O sample.jpg https://via.placeholder.com/800x600.png
wget -O https://share.icloud.com/photos/042ABXKipQ9F3iuny_3HYcy1g
wget -O --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0" "https://share.icloud.com/photos/0c9tLRo-X0PkwJwrF2RwhLmqg"
wget -O --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0" "https://nikonrumors.com/wp-content/uploads/2014/03/Nikon-1-V3-sample-photo.jpg"
wget -O "https://nikonrumors.com/wp-content/uploads/2014/03/Nikon-1-V3-sample-photo.jpg"
wget -O sample.jpg "https://nikonrumors.com/wp-content/uploads/2014/03/Nikon-1-V3-sample-photo.jpg"
gcloud storage cp sample.jpg gs://$BUCKET_NAME/
gcloud storage objects add-iam-policy-binding gs://$BUCKET_NAME/sample.jpg     --member="allUsers"     --role="roles/storage.objectViewer"
gcloud storage buckets add-iam-policy-binding gs://$BUCKET_NAME     --member="allUsers"     --role="roles/storage.objectViewer"
echo "https://storage.googleapis.com/$BUCKET_NAME/sample.jpg"
nano app.py
docker build -t us-central1-docker.pkg.dev/cloud-run-demo-452116/my-repo/cloud-run-app .
docker push us-central1-docker.pkg.dev/cloud-run-demo-452116/my-repo/cloud-run-app
gcloud run deploy cloud-run-app     --image=us-central1-docker.pkg.dev/cloud-run-demo-452116/my-repo/cloud-run-app     --region=us-central1     --platform=managed     --allow-unauthenticated
gcloud logs read "resource.type=cloud_run_revision AND resource.labels.service_name=cloud-run-app" --limit 50
gcloud run services logs read cloud-run-app --region=us-central1 --limit=50
nano Dockerfile
docker build -t us-central1-docker.pkg.dev/cloud-run-demo-452116/my-repo/cloud-run-app .
docker push us-central1-docker.pkg.dev/cloud-run-demo-452116/my-repo/cloud-run-app
gcloud run deploy cloud-run-app     --image=us-central1-docker.pkg.dev/cloud-run-demo-452116/my-repo/cloud-run-app     --region=us-central1     --platform=managed     --allow-unauthenticated
nano app.py
docker push us-central1-docker.pkg.dev/cloud-run-demo-452116/my-repo/cloud-run-app
gcloud run deploy cloud-run-app     --image=us-central1-docker.pkg.dev/cloud-run-demo-452116/my-repo/cloud-run-app     --region=us-central1     --platform=managed     --allow-unauthenticated
gcloud run services logs read cloud-run-app --region=us-central1 --limit=50
gcloud services enable sqladmin.googleapis.com
gcloud sql instances create image-db     --database-version=POSTGRES_14     --cpu=1 --memory=4GB     --region=us-central1
gcloud services enable pubsub.googleapis.com
gcloud pubsub topics create image-uploads
gcloud storage buckets notifications create gs://cloud-run-demo-452116-images     --topic=image-uploads     --event-types=OBJECT_FINALIZE
ls
mkdir cloud-function && cd cloud-function
nano main.py
gcloud functions deploy storage_event_handler     --runtime python39     --trigger-topic image-uploads     --region us-central1     --set-env-vars DB_USER=myuser,DB_PASSWORD=mypassword,DB_NAME=images,DB_INSTANCE_CONNECTION_NAME=cloud-run-demo-452116:us-central1:image-db     --entry-point storage_event_handler
nano requirements.txt
gcloud functions deploy storage_event_handler     --runtime python39     --trigger-topic image-uploads     --region us-central1     --set-env-vars DB_USER=myuser,DB_PASSWORD=mypassword,DB_NAME=images,DB_INSTANCE_CONNECTION_NAME=cloud-run-demo-452116:us-central1:image-db     --entry-point storage_event_handler     --source=.
gcloud services enable cloudfunctions.googleapis.com
gcloud services list --enabled
gcloud functions deploy storage_event_handler     --runtime python39     --trigger-topic image-uploads     --region us-central1     --set-env-vars DB_USER=myuser,DB_PASSWORD=mypassword,DB_NAME=images,DB_INSTANCE_CONNECTION_NAME=cloud-run-demo-452116:us-central1:image-db     --entry-point storage_event_handler     --source=.
ls
cd ..
ls
wget -O new-image.jpg https://hs.sbcounty.gov/cn/Photo%20Gallery/Sample%20Picture%20-%20Koala.jpg
gcloud storage cp new-image.jpg gs://cloud-run-demo-452116-images/
gcloud sql connect image-db --user=myuser --quiet
gcloud sql users set-password myuser --instance=image-db --password=mypassword
gcloud sql connect image-db --user=myuser --quiet
gcloud sql connect image-db --user=myuser --quiet --database=images
gcloud sql databases list --instance=image-db
gcloud sql users list --instance=image-db
gcloud sql connect image-db --user=myuser --quiet --database=images
gcloud sql databases list --instance=image-db
gcloud sql connect image-db --user=myuser --quiet --database=postgres
ls
cd cloud-run-app
ls
gcloud storage cp new-image.jpg gs://cloud-run-demo-452116-images/
gcloud sql connect image-db --user=myuser --quiet --database=images
gcloud functions logs read storage_event_handler --region=us-central1 --limit=50
gcloud functions call storage_event_handler --region=us-central1 --data='{"name":"test-image.jpg","bucket":"cloud-run-demo-452116-images"}'
ls
cd cloud-function
ls
nano main.py
gcloud functions deploy storage_event_handler     --runtime python39     --trigger-topic image-uploads     --region=us-central1     --set-env-vars DB_USER=myuser,DB_PASSWORD=mypassword,DB_NAME=images,DB_INSTANCE_CONNECTION_NAME=cloud-run-demo-452116:us-central1:image-db     --entry-point storage_event_handler     --source=.
cd ..
ls
mv new-image.jpg newer-image.jpg
gcloud storage cp newer-image.jpg gs://cloud-run-demo-452116-images/
gcloud functions logs read storage_event_handler --region=us-central1 --limit=50
pip install pg8000 google-cloud-sql-python-connector
pip install pg8000 cloud-sql-python-connector
pip install google-auth
pip list | grep -E "pg8000|cloud-sql-python-connector"
ls
cd cloud-function
vi main.py
nano main.py
ls
nano requirements.txt
gcloud functions deploy storage_event_handler     --runtime python39     --trigger-topic image-uploads     --region=us-central1     --set-env-vars DB_USER=myuser,DB_PASSWORD=mypassword,DB_NAME=images,DB_INSTANCE_CONNECTION_NAME=cloud-run-demo-452116:us-central1:image-db     --entry-point storage_event_handler     --source=.
ls
nano requirements.txt
gcloud functions deploy storage_event_handler     --runtime python39     --trigger-topic image-uploads     --region=us-central1     --set-env-vars DB_USER=myuser,DB_PASSWORD=mypassword,DB_NAME=images,DB_INSTANCE_CONNECTION_NAME=cloud-run-demo-452116:us-central1:image-db     --entry-point storage_event_handler     --source=.
mv new-image.jpg newish-image.jpg
mv newer-image.jpg newish-image.jpg
gcloud storage cp newish-image.jpg gs://cloud-run-demo-452116-images/
gcloud functions logs read storage_event_handler --region=us-central1 --limit=50
ls
nano main.py
nano requirements.txt
gcloud functions deploy storage_event_handler     --runtime python39     --trigger-topic image-uploads     --region=us-central1     --set-env-vars DB_USER=myuser,DB_PASSWORD=mypassword,DB_NAME=images,DB_INSTANCE_CONNECTION_NAME=cloud-run-demo-452116:us-central1:image-db     --entry-point storage_event_handler     --source=.
ls
rm requirements.txty
ls
nano requirements.txt
cd ..
ls
mv newer-image.jpg newish-image.jpg
ls
gcloud storage cp newish-image.jpg gs://cloud-run-demo-452116-images/
gcloud functions logs read storage_event_handler --region=us-central1 --limit=50
ls
cd cloud-function
ls
nano main.py
gcloud functions deploy storage_event_handler     --runtime python39     --trigger-topic image-uploads     --region=us-central1     --set-env-vars DB_USER=myuser,DB_PASSWORD=mypassword,DB_NAME=images,DB_INSTANCE_CONNECTION_NAME=cloud-run-demo-452116:us-central1:image-db     --entry-point storage_event_handler     --source=.
gcloud storage cp newish-image.jpg gs://cloud-run-demo-452116-images/
cd ..
ls
gcloud storage cp newish-image.jpg gs://cloud-run-demo-452116-images/
gcloud functions logs read storage_event_handler --region=us-central1 --limit=50
gcloud sql connect image-db --user=myuser --quiet --database=images
gcloud functions logs read storage_event_handler --region=us-central1 --limit=50
gcloud services enable sqladmin.googleapis.com
gcloud projects list
gcloud projects add-iam-policy-binding cloud-run-demo-452116     --member=serviceAccount:1057538121289-compute@developer.gserviceaccount.com     --role=roles/cloudsql.client
ls
cd cloud-function
ls
nano main.py
gcloud functions deploy storage_event_handler     --runtime python39     --trigger-topic image-uploads     --region=us-central1     --set-env-vars DB_USER=myuser,DB_PASSWORD=mypassword,DB_NAME=images,DB_INSTANCE_CONNECTION_NAME=cloud-run-demo-452116:us-central1:image-db     --entry-point storage_event_handler     --source=.
ls
cd ..
ls
mv newish-image.jpg test-image.jpg
ls
gcloud storage cp test-image.jpg gs://cloud-run-demo-452116-images/
gcloud functions logs read storage_event_handler --region=us-central1 --limit=50
gcloud sql connect image-db --user=myuser --quiet --database=images
gcloud sql databases list --instance=image-db
gcloud sql connect image-db --user=myuser --quiet --database=postgres
gcloud projects get-iam-policy cloud-run-demo-452116
gcloud sql instances describe image-db | grep ipAddress
psql "host=35.238.77.207 user=myuser dbname=images password=mypassword"
gcloud sql instances describe image-db | grep authorizedNetworks
gcloud sql instances patch image-db --authorized-networks=0.0.0.0/0
gcloud sql instances describe image-db | grep authorizedNetworks
ls
cd cloud-function
ls
nano main.py
gcloud functions deploy storage_event_handler     --runtime python39     --trigger-topic image-uploads     --region=us-central1     --set-env-vars DB_USER=myuser,DB_PASSWORD=mypassword,DB_NAME=images,DB_HOST=PUBLIC_IP_FROM_STEP_1     --entry-point storage_event_handler     --source=.
psql "host=35.238.77.207 user=myuser dbname=images password=mypassword"
gcloud functions deploy storage_event_handler     --runtime python39     --trigger-topic image-uploads     --region=us-central1     --set-env-vars DB_USER=myuser,DB_PASSWORD=mypassword,DB_NAME=images,DB_HOST=35.238.77.207     --entry-point storage_event_handler     --source=.
gcloud functions describe storage_event_handler --region=us-central1
gcloud functions deploy storage_event_handler     --runtime python39     --trigger-topic image-uploads     --region=us-central1     --set-env-vars DB_USER=myuser,DB_PASSWORD=mypassword,DB_NAME=images,DB_HOST=35.238.77.207     --entry-point storage_event_handler     --source=.     --no-allow-unauthenticated
gcloud functions deploy storage_event_handler     --runtime python39     --trigger-topic image-uploads     --region=us-central1     --gen1     --set-env-vars DB_USER=myuser,DB_PASSWORD=mypassword,DB_NAME=images,DB_HOST=35.238.77.207     --entry-point storage_event_handler     --source=.
gcloud config set functions/gen2 off
gcloud functions deploy storage_event_handler     --runtime python39     --trigger-topic image-uploads     --region=us-central1     --set-env-vars DB_USER=myuser,DB_PASSWORD=mypassword,DB_NAME=images,DB_HOST=35.238.77.207     --entry-point storage_event_handler     --source=.
gcloud functions delete storage_event_handler --region=us-central1
gcloud config set functions/gen2 off
gcloud config get-value functions/gen2
gcloud functions deploy storage_event_handler     --runtime python39     --trigger-topic image-uploads     --region=us-central1     --set-env-vars DB_USER=myuser,DB_PASSWORD=mypassword,DB_NAME=images,DB_HOST=35.238.77.207     --entry-point storage_event_handler     --source=.
gcloud beta functions list --region=us-central1 --gen2
gcloud beta functions list --regions=us-central1 --v2
gcloud beta functions delete storage_event_handler --regions=us-central1 --v2
gcloud beta functions delete storage_event_handler --region=us-central1 --v2
gcloud run services delete storage-event-handler --region=us-central1
gcloud config set functions/gen2 off
gcloud functions deploy storage_event_handler     --runtime python39     --trigger-topic image-uploads     --region=us-central1     --set-env-vars DB_USER=myuser,DB_PASSWORD=mypassword,DB_NAME=images,DB_HOST=35.238.77.207     --entry-point storage_event_handler     --source=.
gcloud functions deploy storage_event_handler_v1     --runtime python39     --trigger-topic image-uploads     --region=us-central1     --set-env-vars DB_USER=myuser,DB_PASSWORD=mypassword,DB_NAME=images,DB_HOST=35.238.77.207     --entry-point storage_event_handler     --source=.
ls
cd ..
ls
nano app.py
ls
cd cloud-function
ls
nano main.py
gcloud functions deploy storage_event_handler_v1 \\
gcloud functions deploy storage_event_handler_v1
gcloud functions deploy storage_event_handler_v1 --runtime python39 --trigger-topic image-uploads --region=us-central1 --set-env-vars DB_USER=myuser,DB_PASSWORD=mypassword,DB_NAME=images,DB_HOST=35.238.77.207 --entry-point storage_event_handler --source=.
ls
rm main.py
nano main.py
gcloud functions deploy storage_event_handler_v1   --runtime python39   --trigger-topic image-uploads   --region=us-central1   --set-env-vars DB_USER=myuser,DB_PASSWORD=mypassword,DB_NAME=images,DB_HOST=35.238.77.207   --entry-point storage_event_handler   --source=.
ls
cd ..
ls
gcloud storage cp test-image.jpg gs://cloud-run-demo-452116-images/
gcloud functions logs read storage_event_handler_v1 --region=us-central1 --limit=50
gcloud sql connect image-db --user=myuser --quiet --database=images
gcloud storage cp test-image.jpg gs://cloud-run-demo-452116-images/
gcloud functions logs read storage_event_handler_v1 --region=us-central1 --limit=50
gcloud sql connect image-db --user=myuser --quiet --database=images
ls
gcloud storage cp sample.jpg gs://cloud-run-demo-452116-images/
gcloud sql connect image-db --user=myuser --quiet --database=images
gcloud run services describe cloud-run-app --region us-central1 --format 'value(status.url)'
ls
nano app.py
ls
nano Dockerfile
docker build -t us-central1-docker.pkg.dev/<PROJECT_ID>/<REPO_NAME>/cloud-run-app .
docker push us-central1-docker.pkg.dev/<PROJECT_ID>/<REPO_NAME>/cloud-run-app
docker build -t us-central1-docker.pkg.dev/cloud-run-demo-452116/my-repo/cloud-run-app .
gcloud auth configure-docker us-central1-docker.pkg.dev
docker push us-central1-docker.pkg.dev/cloud-run-demo-452116/my-repo/cloud-run-app
gcloud run deploy cloud-run-app     --image us-central1-docker.pkg.dev/cloud-run-demo-452116/my-repo/cloud-run-app     --region us-central1     --platform managed     --allow-unauthenticated
gcloud run services logs read cloud-run-app --region us-central1 --limit=50
docker build -t us-central1-docker.pkg.dev/cloud-run-demo-452116/my-repo/cloud-run-app .
docker push us-central1-docker.pkg.dev/cloud-run-demo-452116/my-repo/cloud-run-app
gcloud run deploy cloud-run-app     --image us-central1-docker.pkg.dev/cloud-run-demo-452116/my-repo/cloud-run-app     --region us-central1     --platform managed     --allow-unauthenticated
gcloud run services logs read cloud-run-app     --region us-central1     --limit=50
ls
cd cloud-function
ls
nano requirements.txt
cd ..
ls
nano Dockerfile
ls
cd cloud-function
ls
cp requirements.txt ./
cp requirements.txt /.
cp requirements.txt ./cloud-run-app
ls
cd ..
ls
cp ./requirements.txt requirements.txt
cd cloud-function
ls
cp requirements.txt ./requirements.txt
cp requirements.txt ~cloud-run-app/requirements.txt
cp requirements.txt ~/cloud-run-app/requirements.txt
ls
cd ..
ls
docker build -t us-central1-docker.pkg.dev/cloud-run-demo-452116/my-repo/cloud-run-app .
docker push us-central1-docker.pkg.dev/cloud-run-demo-452116/my-repo/cloud-run-app
gcloud run deploy cloud-run-app     --image us-central1-docker.pkg.dev/cloud-run-demo-452116/my-repo/cloud-run-app     --region us-central1     --platform managed     --allow-unauthenticated
ls
gcloud sql connect image-db --user=myuser --database=images
gcloud storage cp test-image.jpg gs://cloud-run-demo-452116-images/
gcloud run services logs read cloud-run-app     --region=us-central1     --limit=50
gcloud sql instances describe image-db | grep ipAddress
gcloud sql instances patch image-db     --authorized-networks=0.0.0.0/0
gcloud run services update cloud-run-app     --region=us-central1     --update-env-vars DB_HOST=35.238.77.207,DB_USER=myuser,DB_PASSWORD=mypassword,DB_NAME=images
gcloud describe buckets
gcloud storage buckets describe
gcloud storage buckets list
gcloud run services update cloud-run-app     --region us-central1     --update-env-vars GCS_BUCKET_NAME=cloud-run-demo-452116-image
ls
nano app.py
docker build -t us-central1-docker.pkg.dev/cloud-run-demo-452116/my-repo/cloud-run-app .
docker push us-central1-docker.pkg.dev/cloud-run-demo-452116/my-repo/cloud-run-app
gcloud run deploy cloud-run-app     --image us-central1-docker.pkg.dev/cloud-run-demo-452116/my-repo/cloud-run-app     --region=us-central1     --platform=managed     --allow-unauthenticated
gcloud run services logs read cloud-run-app --region=us-central1 --limit=50
gcloud storage buckets list
gcloud run services update cloud-run-app     --region us-central1     --update-env-vars GCS_BUCKET_NAME=cloud-run-demo-452116-images
ls
cd cloud-run-app
ls
ls
cd cloud-run-app
cd ..
ls
git init
git config --global init.defaultBranch main
git branch -m main
git add cloud-run-demo
ls
git add cloud-run-app
git commit -m "Initial commit"
git config --global user.email "matt.s.hall@icloud.com"
git config --global user.name "mattshall02"
git commit -m "Initial commit"
git remote add origin https://github.com/mattshall02/cloud-run-demo.git
git push -u origin main
ls
cd cloud-run-app
ls
vi cloudbuild.yaml
nano cloudbuild.yaml
git add cloudbuild.yaml
git commit -m "Add cloudbuild.yaml for CI/CD"
git push origin main
ls
nano README.md
git add README.md
git commit -m "Test CI/CD pipeline"
git push origin main
ls
gcloud builds submit --config=cloud-run-app/cloudbuild.yaml --region=us-central1 .
ls
mv cloud-run-app/Dockerfile ./
mv cloud-run-app/cloudbuild.yaml ./
ls
git commit -m "Moving Dockerfile and cloudbuild.yaml"
git add .
git commit -m "Moving Dockerfile and cloudbuild.yaml"
git push origin main
ls
nano cloudbuild.yaml
git add cloudbuild.yaml
git commit -m "Changes to cloudbuild.yaml"
git push origin main
ls
mv cloud-run-app/requirements.txt ./
ls
git add requirements.txt
git commit "Moved requirements.txt"
git commit -m "Moved requirements.txt"
git push origin main
ls
nano Dockerfile
nano cloudbuild.yaml
mv cloud-run-app/app.py ./
git add app.py
git add .
git commit -m "Moved app.py"
git push origin main
mv app.py cloud-run-app/
ls
git add .
git commit -m "Moved app.py"
git push origin main
ls
nano cloudbuild.yaml
gcloud sql connect image-db --user=myuser --database=images
[200~gcloud run services update cloud-run-app   --region us-central1   --update-env-vars   GOOGLE_CLIENT_ID=1057538121289-raa34pa805k8dbc9qel2q9v2gqm176oi.apps.googleusercontent.com,GOOGLE_CLIENT_SECRET=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,SECRET_KEY=holden1013
gcloud run services update cloud-run-app   --region us-central1   --update-env-vars   GOOGLE_CLIENT_ID=1057538121289-raa34pa805k8dbc9qel2q9v2gqm176oi.apps.googleusercontent.com,GOOGLE_CLIENT_SECRET=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,SECRET_KEY=holden1013
ls
nano requirements.txt
cd cloud-run-app
ls
nano app.py
ls
cd ..
ls
