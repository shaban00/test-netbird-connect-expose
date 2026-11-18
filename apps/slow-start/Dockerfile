# Starts listening on port 8000 only after START_DELAY seconds, to test that
# the response check waits for a slow app instead of failing.
FROM python:3.15-alpine
ENV START_DELAY=30
COPY apps/slow-start/app.py /app/app.py
CMD ["python", "-u", "/app/app.py"]
