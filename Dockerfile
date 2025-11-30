FROM postgres:16

# Environment variables
ENV POSTGRES_USER=khang
ENV POSTGRES_PASSWORD=khang
ENV POSTGRES_DB=trafficdb
ENV POSTGRES_HOST_AUTH_METHOD=trust  # for easy local connections

# Install Python and venv tools
RUN apt-get update && \
    apt-get install -y python3 python3-venv python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Create a virtual environment
RUN python3 -m venv /opt/venv

# Activate venv and install dependencies
COPY requirements.txt /tmp/requirements.txt
RUN /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install -r /tmp/requirements.txt

# Copy loader script
COPY init_db.py /docker-entrypoint-initdb.d/init_db.py
RUN chmod +x /docker-entrypoint-initdb.d/init_db.py

# Expose PostgreSQL port
EXPOSE 5432

# Use custom entrypoint to start PostgreSQL + run loader
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["postgres"]
