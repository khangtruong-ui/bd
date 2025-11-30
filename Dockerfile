FROM bitnami/mysql:8.0

# MySQL env
ENV MYSQL_ROOT_PASSWORD=rootpass
ENV MYSQL_DATABASE=trafficdb

USER root

# Install Python & pip via apt-get (works here)
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip3 install --upgrade pip

# Install Python dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt

# Copy loader script
COPY load_data.py /docker-entrypoint-initdb.d/load_data.py
RUN chmod +x /docker-entrypoint-initdb.d/load_data.py

EXPOSE 3306
