# JSON API on port 5000: reads app-env, echoes request headers and POST bodies.
FROM python:3.15-alpine
COPY apps/python-api/app.py /app/app.py
EXPOSE 5000
CMD ["python", "-u", "/app/app.py"]
