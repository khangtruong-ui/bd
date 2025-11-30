FROM postgres:16

ENV POSTGRES_USER=khang
ENV POSTGRES_PASSWORD=khang
ENV POSTGRES_DB=trafficdb
ENV POSTGRES_HOST_AUTH_METHOD=trust

RUN apt-get update && \
    apt-get install -y python3 python3-venv python3-pip && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /opt/venv

COPY requirements.txt /tmp/requirements.txt
RUN /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install -r /tmp/requirements.txt

COPY init_db.py /docker-entrypoint-initdb.d/init_db.py
RUN chmod +x /docker-entrypoint-initdb.d/init_db.py
EXPOSE 5432

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["postgres"]
