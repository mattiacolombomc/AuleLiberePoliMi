# Use Python 3.12 slim image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install uv for faster dependency installation
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# Copy dependency files
COPY requirements.txt pyproject.toml ./

# Install Python dependencies
RUN uv pip install --system --no-cache -r requirements.txt

# Copy application code
COPY . .

# Create directory for logs
RUN mkdir -p /app/log

# Expose port (Fly.io will set PORT env var)
EXPOSE 8080

# Run the bot
CMD ["python", "bot.py"]
