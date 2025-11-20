FROM python:3.11-slim-bookworm

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt -q

COPY . /app

EXPOSE 5000

CMD python app.py
