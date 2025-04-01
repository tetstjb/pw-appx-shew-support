FROM python:3.11-slim-buster

# Install required dependencies
RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends gcc libffi-dev musl-dev ffmpeg aria2 python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user with UID in the specified range
RUN useradd -m -u 10014 appuser

# Set the working directory inside the container
WORKDIR /app/

# Copy application files to the container
COPY . /app/

# Install Python dependencies
RUN pip3 install --no-cache-dir --upgrade --requirement requirements.txt
RUN pip install pytube

# Set environment variables
ENV COOKIES_FILE_PATH="youtube_cookies.txt"

# Change to the non-root user
USER appuser

# Run the bot as a background process (depending on how your bot is designed)
CMD gunicorn app:app & python3 main.py
