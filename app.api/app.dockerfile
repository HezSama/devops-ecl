# Use a minimal, official Python base image
FROM python:3.10-slim-buster

# Set environment variables for security (prevents Python from writing .pyc files and buffering)
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Set a non-root user for security
RUN groupadd --system appgroup && useradd --system --create-home --gid appgroup appuser

# Update, install dependencies, then clean up to reduce image size
RUN apt-get update && \
    apt-get install -y \
        curl \
        dnsutils \
        libpq-dev \
        gcc \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy and install dependencies securely
COPY --chown=appuser:appgroup app.api/requirements.txt .
RUN pip3 install --no-cache-dir --requirement requirements.txt

# Copy the rest of the application files
COPY --chown=appuser:appgroup . .

# PermissionError: [Errno 13] Permission denied: './logs' -> adding permission to logs.
# Create log directories with appropriate permissions

RUN mkdir -p /app/logs/info /app/logs/error /app/logs/debug /app/logs/warning

# Change ownership and permissions
RUN chmod -R 755 /app && chmod -R 777 /app/logs && chown -R appuser:appgroup /app/logs

# Switch to non-root user
USER appuser

# Set the entrypoint and command
ENTRYPOINT [ "python3" ]
CMD [ "app.api/main.py" ]
