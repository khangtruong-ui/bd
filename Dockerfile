FROM python:3.11-slim-bookworm

WORKDIR /app

RUN pip install -r requirements.txt 

COPY . /app

EXPOSE 5000

CMD python app.py
