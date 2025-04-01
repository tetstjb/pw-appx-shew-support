FROM python:3.10.8-slim-buster

# Create a non-root user with a fixed UID in the required range
RUN useradd -m -u 10014 appuser

# Update and install necessary dependencies
RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends gcc libffi-dev musl-dev ffmpeg aria2 python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app/

# Copy files to the container
COPY . /app/

# Install Python dependencies
RUN pip3 install --no-cache-dir --upgrade --requirement requirements.txt
RUN pip install pytube

# Set environment variables
ENV COOKIES_FILE_PATH="youtube_cookies.txt"

# Change to non-root user with the correct UID
USER 10014

# Run the application
CMD gunicorn app:app & python3 main.py
