# Base: PostgreSQL
FROM postgres:16

# Set environment variables for PostgreSQL
ENV POSTGRES_USER=khang
ENV POSTGRES_PASSWORD=khang
ENV POSTGRES_DB=trafficdb

# Allow remote access (listen on all interfaces)
RUN echo "listen_addresses='*'" >> /var/lib/postgresql/data/postgresql.conf

# Allow all IPs to connect (for dev purposes)
RUN echo "host all  all  0.0.0.0/0  md5" >> /var/lib/postgresql/data/pg_hba.conf

# Install Python + pip + requirements
RUN apt-get update && apt-get install -y python3 python3-pip && rm -rf /var/lib/apt/lists/*
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt

# Copy the loader script
COPY init_db.py /docker-entrypoint-initdb.d/init_db.py
RUN chmod +x /docker-entrypoint-initdb.d/init_db.py
