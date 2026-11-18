FROM python:3.15-alpine
RUN pip install --no-cache-dir redis==6.4.0
COPY app.py /app/app.py
CMD ["python", "-u", "/app/app.py"]
