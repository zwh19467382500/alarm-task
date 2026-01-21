FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY .env .
COPY jpush_service.py .

EXPOSE 8001

CMD ["python", "jpush_service.py", "--host", "0.0.0.0", "--port", "8001"]