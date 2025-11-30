FROM python:3.11-slim-bookworm

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt -q

COPY app.py /app

EXPOSE 8000

CMD python app.py
