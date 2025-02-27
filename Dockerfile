# Use Python as the base image
FROM python:3.9

# Set the working directory
WORKDIR /app

# Copy requirements.txt and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY cloud-run-demo/app.py .

# Expose the port (Cloud Run uses 8080 by default)
EXPOSE 8080

# Run the application
CMD ["python", "app.py"]
